User.create(first_name: 'Super', last_name: 'Admin', email: 'super.admin@student.hpi.uni-potsdam.de', username: 'superadmin', password: 'test', password_confirmation: 'test', superadmin: true)
User.create(first_name: 'Karl', last_name: 'Algo', email: 'karl.algo@student.hpi.uni-potsdam.de', password: 'test', password_confirmation: 'test')
User.create(first_name: 'Sara', last_name: 'Algo', email: 'sara.algo@student.hpi.uni-potsdam.de', password: 'test', password_confirmation: 'test')

User.create(first_name: 'Hans', last_name: 'Epic', email: 'hans.epic@student.hpi.uni-potsdam.de', password: 'test', password_confirmation: 'test')
User.create(first_name: 'Laura', last_name: 'Epic', email: 'laura.epic@student.hpi.uni-potsdam.de', password: 'test', password_confirmation: 'test')
User.create(first_name: 'Franz', last_name: 'Epic', email: 'franz.epic@student.hpi.uni-potsdam.de', password: 'test', password_confirmation: 'test')
User.create(first_name: 'Thomas', last_name: 'Epic', email: 'thomas.epic@student.hpi.uni-potsdam.de', password: 'test', password_confirmation: 'test')
User.create(first_name: 'Carlos', last_name: 'Epic', email: 'carlos.epic@student.hpi.uni-potsdam.de', password: 'test', password_confirmation: 'test')

Chair_Wimi.create(admin: false, representative: false, user_id: 4, chair_id: 1)
Chair_Wimi.create(admin: false, representative: false, user_id: 5, chair_id: 1)
Chair_Wimi.create(admin: false, representative: false, user_id: 6, chair_id: 1)
Chair_Wimi.create(admin: false, representative: false, user_id: 7, chair_id: 1)
Chair_Wimi.create(admin: false, representative: false, user_id: 8, chair_id: 1)

Project.create(name: 'In-Memory Data Management for Enterprise Systems', chair_id: 1)
Project.create(name: 'Tools & Methods for Enterprise Systems Design and Engineering', chair_id: 1)
Project.create(name: 'In-Memory Data Management for Life Sciences', chair_id: 1)
Project.create(name: 'openHPI', chair_id: 1)

## Hiwis mit Stundenzetteln ##

User.create(first_name: 'Peter', last_name: 'Hiwi', email: 'peter.hiwi@student.hpi.uni-potsdam.de', password: 'test', password_confirmation: 'test')
User.create(first_name: 'Paul', last_name: 'Hiwi', email: 'paul.hiwi@student.hpi.uni-potsdam.de', password: 'test', password_confirmation: 'test')

Project_User.create(user_id: 9, project_id: 4)
Project_User.create(user_id: 10, project_id: 4)

Time_Sheet.create(month: 2, year: 2016, salary: 400, salary_is_per_month: true, workload: 10, workload_is_per_month: true, user_id: 9, project_id: 4)
Time_Sheet.create(month: 2, year: 2016, salary: 400, salary_is_per_month: true, workload: 10, workload_is_per_month: true, user_id: 10, project_id: 4)

Work_Day.create(date: 2016-02-01, start_time: '08:00:00', end_time: '19:00:00', break: 60, user_id: 9, project_id: 4)
Work_Day.create(date: 2016-02-02, start_time: '08:00:00', end_time: '19:00:00', break: 60, user_id: 9, project_id: 4)
Work_Day.create(date: 2016-02-01, start_time: '08:00:00', end_time: '16:00:00', break: 60, user_id: 10, project_id: 4)
Work_Day.create(date: 2016-02-02, start_time: '08:00:00', end_time: '17:00:00', break: 60, user_id: 10, project_id: 4)

## Alle Fachgebiete ##

Chair.create(name: 'Enterprise Platform and Integration Concepts')
Chair.create(name: 'Internet-Technologien und Systeme')
Chair.create(name: 'Human Computer Interaction')
Chair.create(name: 'Computergrafische Systeme')
Chair.create(name: 'Systemanalyse und Modellierung')
Chair.create(name: 'Software-Architekturen')
Chair.create(name: 'Informationssysteme')
Chair.create(name: 'Betriebssysteme und Middleware')
Chair.create(name: 'Business Process Technology')
Chair.create(name: 'Knowledge Discovery and Data Mining')
Chair.create(name: 'School of Design Thinking')

## Uns anlegen ##

User.create(first_name: 'Mandy', last_name: 'Klingbeil', email: 'mandy.klingbeil@student.hpi.uni-potsdam.de', identity_url: 'https://openid.hpi.uni-potsdam.de/user/mandy.klingbeil')
User.create(first_name: 'Fabian', last_name: 'Paul', email: 'fabian.paul@student.hpi.uni-potsdam.de', identity_url: 'https://openid.hpi.uni-potsdam.de/user/fabian.paul', signature: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAMgAAABhCAYAAACTS+64AAAABmJLR0QA/wD/AP+gvaeTAAAOE0lEQVR4nO2debhVVRXAf28A5AUPJPWpISqiYebEV6LGh0MO5ZATojlFWlgZmRqKlaaIQw6oOUOJpmmJYYipiIrDZ+aAA2bOIiKmoiIxxEPee/2x7v7WPnd659x7zz3nvrd+33e+770z7LPOuWfvvfZae60NhmEYhmEYhmEYhhGddZIWwEgHuwN3AackLEfSbA2cDcwFlgEdwGfAzcDABOUyEuRooA35GNYA6yYrTtXpC4wDXkDeQaHtyaQENJJjf6AV/QhWAr0Slah6tACT0Z7CfwdzgUuBM4C/eMe2SkRSIxG2QT4G/+O4JlGJqkN/4CJgBfrc7cCDwGigd9b5R3rnDa2emEaSrAPMJ7fl3ChJoWKmHjgBWII+cxtwO9JYFOKezLkLMmUY3YCrydWxf5uoRPGyLfAMweedldlfjIO888+MU0AjPXwLUSn8j2UJMCBJoWKiB/AbguOsfyPvoDPWB97LXPMhXfP9GFmsA7xJbu9xTJJCxcQQgr1GK3AW0DPEtQ3AHO/a78Yko5EyziK3ctyfqETxcDRB69QzdK5O+VziXXtLxaUzUsnm5FqtVmT2dxV6ANcSHIRfmNkflm+jKuhzQFOFZTRSim/Pd9tpiUpUWdYHHkGf7T/AXhHLaATeylz/X0RNM7oBW6Lecrc9i+jaXYFG4DWCXu+NSyhnlFfG8RWTzkg9UwhWjlXAVxKVqLJsjDYAN1L6bIA/Zcp4B/N5dBs2AlYTrCA/TVSieBgJHFhmGY8h72du+eIYtcJFBCvHvUBdohKll+vQWQVbJiyLUSU+RivHR8CGyYqTakagFqyFwGaJShOdfsBhwJXAecCXkhUn/fQk2Ht8J1lxaoJz0Pe1FPng0s5IZE5Ztio9O0mhaoFpBD3JRjjOITgd5zpyZ/mmgX2BJygcwzIvOdHSzwiCL+ugZMWpOfZBfCnu/c0HNk1UImVHxJDg/76fIg3iZ94+myJTgBZgMcEXOCJRiWqTDRE1xb3DxcB2CcrTHzHZ+z6tT4BfIUaFp739UzFjTF4ayG1drDUpnTrgYvQ9fkgy8ekHE2z0WpGox/5I5XjLO/ZXuo4TuOL4Zt1pwLuZv18DjkNm7o5FwknPRSLm0qhfR6EHcBUyVojLwXcq+l4fpnqtczMyYTLbVO+mwexOMAhsKlY5CnIgOrh8Hplo9xMKD+Lc9ja1bf49AX2WHWO8zzXefaph3foa8IZ3z48JhiacAnyeOdaOZGQxCjAEMUt2IAO1LTL765GsHYsoXkkmVFneStEAvI76LqLM3I1KX0TF6gBmxngfkJ79f+jvcx+wQeZYE3Cbd2wVXTOmp2L0A15CW5JDCpy3CTAY+CKqVrmgovtiljEu/KQKJ1XhfleiPpI4qAMmoprAGmTWtVPphhJMUbSAeHvNmqcBia92L+z8iNe75A1xt4hxUAe8iMj/AdUZS01A33UcmRev8Mr/BNjNO3YcsNw7Pgdp7Iwi+BaWmUQbPPZBddhaTNpwAPrsZ1TpnucRn+N1Mvo8r6Nqch8ku6M71gZMwgbjnXIcQUdWn4jX7+9df0BlRasK/0DVneYq3XMmagSpJD9Ef4s3UFPyDsCr3rFSAsG6JTuj2To+orTQ2T9mrl+JDEBrieHoRzOxSvdsQD3VF1ew3O3RcOhFyFixN5KRxTekzEacwEYnDEStKa3IZLWoNCFhpR3AnysnWtWYhj5/tT6akejHuneFylwXrXRrkRkP+xE0736OjH0siCsETUj37l7eD0os52CvjHK97L2RcNUjqZxe3AdRL/IxADFtdiCzWKuFi+tfiIT5lkt2eqEbkCz7fq8xD/h6Be7VLagD7kRf3hVllHU9akMvx/ozDHE0OpmOLaMsx95eeaPzHPe92qX0nqWwGWrQ+EWFyjyTYGVY4/29FDFbW68RgXMJ6qPltNYLM+XcU0YZe5ObSqgca1gdokqs9crbLc95LkHDy2XcqxANSKU/GEnc8H1gTyTJRQdiZu1fgft8lfwO2zYkrn6Dwpca+TgcdR69hjgHS2V39AcZW2IZ+xP09Lqt1KCsvsgkO1fOckRly2ZH75xxJd4rmzrkeWagsxGKbeWmA2ouUO7D1L7Trz/S27YQLotlRRiGttSfUf4P5HTp5UQ3DYO0qM6C1op68ZdRWkaRocArBH0AhTIhul60jcq0st9A5Y+yzSB6fMgg4II8Zf2LcPmC00QzIvOZiDX0adTo46uMlehti7IhOo9qLeXbwDdHdd1S1gMZjq6t0YpYXNxcqFtLKO9QgmlCZ1H8pc7NnPdECffyaQQuIxhbsRQZKI9GKuhAJMeW/6P7ibBXIRMEi43h1kVSoc4hNzdZBzCG2hhn9EN+qyuRjJO+GlxoayfmRYea0I+vXJViAHAiuQ+xCBnPTAC+3EkZOyHTH1xlPQTxx7iyorSCfZGP0amNbYjdv7OP5YPM+ddGuFc2vYG7UbmXAePJ9QWd5p1zR2ZfC/AHgiG57yKxGT9GrIpnZeR7huIfUtoniG6P9BCPogaKfJVgATKX71LgZ8i4bSwyGzk2eiKrHjlBppRYznBgOrkB/YUedhGwa55yhqAZUtqRlwCaC3cx4Y0GIwgG+HyKjAHCMAvpAb8Z8vx83Ord+ynEMZfNEejH/Sq5nvqd0YF7mO0dxKHpG1rSlhe5HvntL0M++nzPsQrJHzYJaRATcTA3IDquE2om0Qc8A5Ap0dlrgbjtBiS4agqiP/rdfxvSEjgGEpwuf2pmfy+0R8m2XvUkd15YH6SV8e/1APk/0ELUUZ6B4gjv3nPJPwYbhVaO5YjFKR/1mXNnEIwFb0OmhNwNnExwPHVV5pyPyniGStKIqO1Xkxum7bZXkHli+5CSpbEvJfgjRs0wvjlBT6y/tSEPms0Wmfu68UA7YpFqQmfMdhAMyjnQ2z8MednHA48jrfwSpMXcFjgd9f53IEaHk6hu3HQdMiDuQHqwfIvi/AgdZ6wkvJ+lDjEabEzxntTNvH4uZLlx0BPpsW8kmDfNbWuRRODjSGFusDGooC9SWmv5kFfGaoIDy86izrZBVB43PvE9vZOzznXOxvcR07FviSq2PUEymQt38mQYlXWsBfHK+xV4zxhkcOrdqzGUXYxeSIN2M/lN2a1IKO9YUuyD2RX9mD+gtOQAW1P4wzw3ZBn+NHJfzctuGZ2FZyVBVW4BoqPeRnCQ+iziz0kq24avXh2G+ByORaZ3+I3IQqQyxcE4tJUeFNM9HH0Qy9MtBFVAfzxxFxKNGLs5tlwGoN7tVmRwXQq9Ef3WfxELCD8IdvjXv0T+nuz+rPOWIwNRf7y0CWLtGhzx/nHQQmFrjNtmE28QUgtaGR+hsjp9I7ALoiU8Rv5nXYlY5EYDX6jgvWOljqDZsVTvtmMoEtA/CZkOEnVKypYEX2ohefZCKuNS4CbSZ5XJxy/J/XA+RowWI6lO73a5d+/5yPitFDZCEgJOQowdvj/J31YgzuFRpGDFrFJe8MnoxMPbgaMqJ05kmpBApO29fb9HAnry0QN55jUxy1VJ1kPUq17IuGkBoiJWi16Iyrqvt28+Yk18HjFuLEU8081I792MVIghSG+8FYXXtXe9/hzEVfAoMi2oJhmGdrlvUr3IuEJMI7cFWoxl6as09Yi5vLNsM2G2z5GKdT3ite8yQVXN6LLMrcTseQzBUehLvx9xBrr/tyhynVE6DcgYbTqa5K/Qthbp7R5EKsPPkblkiatNceFCXjuQh02STVHz37uIGuJbxA5PTrRuxXrI8ng7I2O8XRFH5SCqODs2DRyEfnyzSFaFaUBXiG0D9sjsb0TNtJa1z6gaA9DU+p+QfNrP8WhlzU5G8F5m/9RqC2V0X/xkxEmnjNwBNRK8QG43/lTmWDmRh4YRGj9Zwl0Jy9KIzAnqQMyA+SblPZ45/ngV5TK6Kc2oypIG1ep0OjcSOG+5VRAjdi5EP8gxyYrCYDSM90kKByrdi1UQo0q42a8Pkbzj7YGMLGsovqyYWyTSVkw1YqcJicJK2rFzDNqTdZYN3sVP3NHJeYbRJeiHzvZ9g85nk76fOfeGmOUyuglpz1AxAVgfnaW7usi5Tagh4e2Y5TKMxNkEzWkbJmH1dqgqdmiMchlGKrgJ+dhXEy6A6VC0giS5PrhhxM52aDaRy0Necz4ahVaJbOaGkVpmIx/7UsKHlLrkD4/GJZRhpIE9UFXp9JDXNKIpRi+MSS7DSAVzkQ/9fcInCRiBVqr9YpLLMBJnF/RDHx/hukvQTCWlZGw3jJrgb+jYI0oeVbdIzfQ4hDKMNDAIjQiMsirrDmivU4kl1QwjlUxEPvJ2oqX6dBnbW5H1LQyjy1GPxp7MiXBdE5qmshaXhzaMUOyGqknfi3DdGO+6ctbgMIxUcw06rSRshvg6JC69A1keIOmYFcOIDZeELEqyBT+r+2lxCGUYaWAwpSWkcxlMllDa6reGURP4KUPDrru9j3fNr2OSyzBSwXnoxx4mgKsemIc6FFO/mIpRu6QhotCpR8sIl9b/eHSNismImdcwuixTkN7gvRDnNqNrj79DSlYxNbouaehB3NJaK0KcOxFdT2I8xWPUDaNLcA/SI8zr5Lw90bGKBUUZ3YYw2RAHoul/ViLLPxtG7KRBxXJqUiEPek/gTiT9D8CJwMtxC2UYaWEq0jMsynOsBxoj0gH8ropyGUYqcAvitBP0iDcgq+i6yvEQ3WxZL8MAGE5uPHlfYIa3/59EizA0jC5DPeLTcLNyz/b+dytJmbfc6NaMJf9SwtOxnsMwqANORpJOrwX+jiy9YBiGRx0yODcMwzAMwzAMwzCMbsf/AciwKkEUPd8bAAAAAElFTkSuQmCC')

Chair_Wimi.create(admin: true, representative: false, user_id: 11, chair_id: 1)
Chair_Wimi.create(admin: false, representative: true, user_id: 12, chair_id: 1)
