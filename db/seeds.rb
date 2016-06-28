# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Categories
Category.create(name: "Action")   # id = 1
Category.create(name: "Comedy")   # id = 2
Category.create(name: "Thriller") # id = 3
Category.create(name: "Family")   # id = 4
Category.create(name: "Drama")    # id = 5

#Videos 
Video.create(title:"The Walking Dead", description:"Rick Grimes is a former Sheriff's deputy who has been in a coma for several months after being shot while on duty. When he wakes, he discovers that the world has been taken over by zombies, and that he seems to be the only person still alive. After returning home to discover his wife and son missing, he heads for Atlanta to search for his family. Narrowly escaping death at the hands of the zombies on arrival in Atlanta, he is aided by another survivor Glenn who takes Rick to a camp outside the town. There Rick finds his wife Lori and son Carl, along with his partner/best friend Shane and a small group of survivors who struggle to fend off the zombie hordes; as well as competing with other survivor groups who are prepared to do whatever it takes to survive", large_video_cover:"/tmp/the_walking_dead_large.jpg", small_video_cover:"/tmp/the_walking_dead.jpg")

Video.create(title:"Dexter", description:"Meet Dexter Morgan. By day he's a blood spatter pattern expert for the Miami Metro police department. But by night - he takes on an entirely different persona: serial killer. But Dexter isn't your average serial killer as he only kills people who fit a very prolific and precise \"moral code\" taught to him by his late father Harry (he didn't kill Harry, honest), and developed very thoroughly throughout each kill. While dealing with his daily activities and his boss, Sgt. Doakes, the one man who may or may not know the truth about his after-hours activities, he is given a friendly message by a guy referred to only as \"The Ice Truck Killer\" - a crime scene where there is no blood. This shocking discovery turns Dexter's world completely upside down. The Ice Truck Killer wants Dexter to play his game and Dexter is very eager to take on this cat-and-mouse chase throughout Miami.", large_video_cover:"/tmp/dexter_large.jpg", small_video_cover:"/tmp/dexter.jpg")

Video.create(title:"How I Met Your Mother", description:"The year is 2030. Ted Mosby is relaying the story of how he met his wife to his daughter and son. The story starts in the year 2005, when then twenty-seven year old architect Ted was spurred on to want to get married after his best friends from his college days at Wesleyan, lawyer Marshall Eriksen, who was his roommate at the time and kindergarten teacher Lily Aldrin, got engaged after nine years of dating each other. Ted's new quest in life was much to the dismay of his womanizing friend, Barney Stinson. But soon after Marshall and Lily's engagement, Ted believed that his life mate was going to be news reporter and aspiring news anchor Robin Scherbatsky, who, despite having had a romantic relationship with her after this time, ended up being who the kids know as their \"Aunt\" Robin. As Ted relays the story to his kids, the constants are that their Uncle Marshall, Aunt Lily, Uncle Barney and Aunt Robin are always in the picture and thus have something to do with how he got together", large_video_cover:"/tmp/himym_large.jpg", small_video_cover:"/tmp/himym.jpg")

Video.create(title:"House of Cards", description:"Majority House Whip Francis Underwood takes you on a long journey as he exacts his vengeance on those he feels wronged him - that is, his own cabinet members including the President of the United States himself. Dashing, cunning, methodical and vicious, Frank Underwood along with his equally manipulative yet ambiguous wife, Claire take Washington by storm through climbing the hierarchical ladder to power in this Americanized recreation of the BBC series of the same name.", large_video_cover:"/tmp/house_of_cards_large.jpg", small_video_cover:"/tmp/house_of_cards.jpg")


Video.create(title:"Nikita", description:"When she was a deeply troubled teenager, Nikita was rescued from death row by a secret U.S. agency known only as Division, who faked her execution and told her she was being given a second chance to start a new life and serve her country. What they didn't tell her was that she was being trained as a spy and assassin. Throughout her grueling training at Division, Nikita never lost her humanity, even falling in love with a civilian. When her fiancé was murdered, Nikita realized she had been betrayed and her dreams shattered by the only people she thought she could trust, so she did what no one else before her had been able to do: she escaped. Now, after three years in hiding, Nikita is seeking retribution and making it clear to her former bosses that she will stop at nothing to expose and destroy their covert operation.", large_video_cover:"/tmp/nikita_large.jpg", small_video_cover:"/tmp/nikita.jpg")

Video.create(title:"The Big Bang Theory", description:"Leonard Hofstadter and Sheldon Cooper are both brilliant physicists working at Caltech in Pasadena, California. They are colleagues, best friends, and roommates, although in all capacities their relationship is always tested primarily by Sheldon's regimented, deeply eccentric, and non-conventional ways. They are also friends with their Caltech colleagues mechanical engineer Howard Wolowitz and astrophysicist Rajesh Koothrappali. The foursome spend their time working on their individual work projects, playing video games, watching science-fiction movies, or reading comic books. As they are self-professed nerds, all have little or no luck with popular women. When Penny, a pretty woman and an aspiring actress originally from Omaha, moves into the apartment across the hall from Leonard and Sheldon's, Leonard has another aspiration in life, namely to get Penny to be his girlfriend.", large_video_cover:"/tmp/the_big_bang_theory_large.jpg", small_video_cover:"/tmp/the_big_bang_theory.png")

#Video Categories
VideoCategory.create(video_id: 1, category_id: 1)
VideoCategory.create(video_id: 1, category_id: 3)
VideoCategory.create(video_id: 1, category_id: 5)
VideoCategory.create(video_id: 2, category_id: 3)
VideoCategory.create(video_id: 2, category_id: 4)
VideoCategory.create(video_id: 2, category_id: 5)
VideoCategory.create(video_id: 3, category_id: 2)
VideoCategory.create(video_id: 3, category_id: 4)
VideoCategory.create(video_id: 3, category_id: 5)
VideoCategory.create(video_id: 4, category_id: 3)
VideoCategory.create(video_id: 4, category_id: 5)
VideoCategory.create(video_id: 5, category_id: 1)
VideoCategory.create(video_id: 5, category_id: 5)
VideoCategory.create(video_id: 6, category_id: 2)
VideoCategory.create(video_id: 6, category_id: 4)

