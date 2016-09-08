module I18n::Tasks::Scanners
  class ModelScanner < FileScanner
    include I18n::Tasks::Scanners::OccurrenceFromPosition
    
    def initialize(**args)
      super
      @patterns = [
        [/\#  (?<a>[\w_]+)/, 'activerecord.attributes.%{model}.%{a}']
      ]
    end
    
    MODEL_NAME = /[^\/]+(?=\.rb)/
    
    def scan_file(path)
      return [] unless path =~ /.*\/models\/.*.rb/
      model = path[MODEL_NAME]
      text = read_file(path)
      @patterns.flat_map do |pattern, key|
        result = []
        text.scan(pattern) do |_|
          match    = Regexp.last_match
          matches  = Hash[match.names.map(&:to_sym).zip(match.captures)]
          matches[:model] = model
          occ = occurrence_from_position(path, text, match.offset(0).first)
          occ = Results::Occurrence.new(
              path: occ.path, pos: occ.pos, 
              line_num: occ.line_num, line_pos: occ.line_pos, line: occ.line,
              raw_key: occ.raw_key, default_arg: matches[:a])
          result << [key % matches, occ]
        end
        result
      end
    end
  end
end

module I18n::Tasks
  module MissingKeys
    # keys used in the code missing translations in locale
    def missing_used_tree(locale)
      used_tree(strict: true).select_keys { |key, _node|
        b = locale_key_missing?(locale, key)
        b and not _node.data[:occurrences].all? &:default_arg
      }.set_root_key!(locale, type: :missing_used)
    end
  end
end

module I18n::Tasks::Scanners
  class Results::Occurrence
    def default_arg=(a)
      @default_arg = a
    end
  end

  # Scans for I18n.t(key, scope: ...) usages
  # both scope: "literal", and scope: [:array, :of, 'literals'] forms are supported
  # Caveat: scope is only detected when it is the first argument
  class PatternWithScopeScanner
    
#    def initialize(**args)
#      super
#      @ignore_lines_res['erb'] = /^\\s*<%\\s*#(?!\\si18n-tasks-use)|i18n-ignore/
#    end

    protected

    def default_pattern
      # capture the first argument and scope argument if present
      /#{translate_call_re} (?:[\( ] \s*|(?=['"])) (?# fn call begin )
      (#{literal_re})                (?# capture the first argument)
      (?: \s*,\s* #{scope_arg_re} )? (?# capture scope in second argument )
      (?: \s*,\s* (default:|:default) )?
      /x
    end

    # Given
    # @param [MatchData] match
    # @param [String] path
    # @return [String] full absolute key name with scope resolved if any
    def match_to_key(match, path, location)
      key   = super
      scope = match[1]
      def_arg = match[2]
      if def_arg
        location.default_arg = "--not extracted--"
#        location = Results::Occurrence.new(
#          path: location.path, pos: location.pos, 
#          line_num: location.line_num, line_pos: location.line_pos, line: location.line,
#          raw_key: location.raw_key, default_arg: "--not extracted--")
      end
      if scope
        scope_ns = scope.gsub(/[\[\]\s]+/, ''.freeze).split(','.freeze).map { |arg| strip_literal(arg) } * '.'.freeze
        "#{scope_ns}.#{key}"
      else
        key unless match[0] =~ /\A\w/
      end
    end
  end
  
  # Maps the provided patterns to keys.
  # From some reason, the class provided by the gem can not be found
  class PatternMapper < FileScanner
    include I18n::Tasks::Scanners::RelativeKeys
    include I18n::Tasks::Scanners::OccurrenceFromPosition
    include I18n::Tasks::Scanners::RubyKeyLiterals

    # @param patterns [Array<[String, String]> the list of pattern-key pairs
    #   the patterns follow the regular expression syntax, with a syntax addition for matching
    #   string/symbol literals: you can include %{key} in the pattern, and it will be converted to
    #   a named capture group, capturing ruby strings and symbols, that can then be used in the key:
    #
    #       patterns: [['Spree\.t[( ]\s*%{key}', 'spree.%{key}']]
    #
    #   All of the named capture groups are interpolated into the key with %{group_name} interpolations.
    #
    def initialize(**args)
      super
      @patterns = configure_patterns(config[:patterns] || [])
    end

    protected

    # @return [Array<[absolute key, Results::Occurrence]>]
    def scan_file(path)
      text = read_file(path)
      @patterns.flat_map do |pattern, key|
        result = []
        text.scan(pattern) do |_|
          match    = Regexp.last_match
          matches  = Hash[match.names.map(&:to_sym).zip(match.captures)]
          if matches.key?(:key)
            matches[:key] = strip_literal(matches[:key])
            next unless valid_key?(matches[:key])
          end
          result << [absolute_key(key % matches, path),
           occurrence_from_position(path, text, match.offset(0).first)]
        end
        result
      end
    end

    private

    KEY_GROUP = "(?<key>#{LITERAL_RE})"

    def configure_patterns(patterns)
      patterns.map do |(pattern, key)|
        [pattern.is_a?(Regexp) ? pattern : Regexp.new(pattern % {key: KEY_GROUP}), key]
      end
    end
end
end