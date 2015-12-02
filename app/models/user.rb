class User < ActiveRecord::Base

  DIVISIONS = [
    ['', ''],
    [
      'Enterprise Platform and Integration Concepts',
      'Enterprise Platform and Integration Concepts'
    ],
    [
      'Internet-Technologien und Systeme',
      'Internet-Technologien und Systeme'
    ],
    [
      'Human Computer Interaction',
      'Human Computer Interaction'
    ],
    [
      'Computergrafische Systeme',
      'Computergrafische Systeme'
    ],
    [
      'Algorithm Engineering',
      'Algorithm Engineering'
    ],
    [
      'Systemanalyse und Modellierung',
      'Systemanalyse und Modellierung'
    ],
    [
      'Software-Architekturen',
      'Software-Architekturen'
    ],
    [
      'Informationssysteme',
      'Informationssysteme'
    ],
    [
      'Betriebssysteme und Middleware',
      'Betriebssysteme und Middleware'
    ],
    [
      'Business Process Technology',
      'Business Process Technology'
    ],
    [
      'School of Design Thinking',
      'School of Design Thinking'
    ],
    [
      'Knowledge Discovery and Data Mining',
      'Knowledge Discovery and Data Mining'
    ]
  ]


  LANGUAGES = [
    ['', ''],
    [
      'English',
      'en'
    ],
    [
      'Deutsch',
      'de'
    ],
  ]


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :holidays
  has_many :expenses
  has_many :trips
  has_and_belongs_to_many :publications
  has_and_belongs_to_many :projects

  def name
    "#{first} #{last_name}"
  end

  def name=(fullname)
    first, last = fullname.split(' ')
    self.first = first
    self.last_name = last
  end
end
