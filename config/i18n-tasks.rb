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
    
    # <% I18n::Tasks.add_scanner 'I18n::Tasks::Scanners::PatternMapper',
#  only: %w(*/models/*.rb),
#  patterns: [['\\#  (?<a>[\\w_]+)', 'activerecord.attributes.aaaaa.%{a}']] %> 
    
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
end