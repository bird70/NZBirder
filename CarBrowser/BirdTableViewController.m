
//
//  BirdTableViewController.m
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 2/6/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import "BirdTableViewController.h"
#import "Bird.h"
#import "BirdTableViewCell.h"
#import "BirdDetailViewController.h"

//#import "DetailViewController.h"
//#import "ModelController.h"


@interface BirdTableViewController ()

@end

@implementation BirdTableViewController
@synthesize birds;
@synthesize filteredBirdsArray;
@synthesize birdSearchBar;



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Don't show the scope bar or cancel button until editing begins
    [birdSearchBar setShowsScopeBar:NO];
    [birdSearchBar sizeToFit];
    
    /*
    // Hide the search bar until user scrolls up
    CGRect newBounds = self.tableView.bounds;
    newBounds.origin.y = newBounds.origin.y + birdSearchBar.bounds.size.height;
    self.tableView.bounds = newBounds;
    */
    
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    // Do not show a separator between cells (as this is already part of the custom background images
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.contentInset = inset;
    
    [self setBirds:@[
    [Bird birdWithName:@"Fantail" maoriname:@"Piwakawaka" image:[UIImage imageNamed:@"Grey_Fantail.jpg"] sound:@"fantail" description:@"Known for its friendly ‘cheet cheet’ call and energetic flying antics, the aptly named fantail is one of the most common and widely distributed native birds on the New Zealand mainland.\n\nIt is easily recognized by its long tail which opens to a fan. It has a small head and bill and has two colour forms, pied and melanistic or black. The pied birds are grey-brown with white and black bands.\n\n<b>Where is it found?</b>\nThe fantail is widespread throughout New Zealand and its offshore islands, including the Chatham Islands and Snares Islands. It is common in most regions of the country, except in the dry, open country of inland Marlborough and Central Otago, where frosts and snow falls are too harsh for it. It also breeds widely in Australia and some Pacific Islands.\nThe fantail is one of the few native bird species in New Zealand that has been able to adapt to an environment greatly altered by humans. Originally a bird of open native forests and scrub, it is now also found in exotic plantation forests, in orchards and in gardens. At times, fantails may appear far from any large stands of shrubs or trees, and it has an altitudinal range that extends from sea level to the snow line.\n\nFantail facts\n    There are about 10 sub-species of fantail, three of which live in New Zealand: the North Island fantail, the South Island fantail and the Chatham Islands fantail.\nFantails use their broad tails to change direction quickly while hunting for insects. They sometimes hop around upside-down amongst tree ferns and foliage to pick insects from the underside of leaves. Their main prey are moths, flies, spiders, wasps, and beetles, although they sometimes also eat fruit. They seldom feed on the ground.\nThe fantail lifespan is relatively short in New Zealand (the oldest bird recorded here was 3 years old, although in Australia they have been recorded up to 10 years). Fantails stay in pairs all year but high mortality means that they seldom survive more than one season.\nThe success of the species is largely due to the fantail’s prolific and early breeding. Juvenile males can start breeding between 2–9 months old, and females can lay as many as 5 clutches in one season, with between 2–5 eggs per clutch.\nFantail populations fluctuate greatly from year to year, especially when winters are prolonged or severe storms hit in spring. However, since they are prolific breeders, they are able to spring back quickly after such events.\nBoth adults incubate eggs for about 14 days and the chicks fledge at about 13 days. Both adults will feed the young, but as soon as the female starts building the next nest the male takes over the role of feeding the previous brood. Young are fed about every 10 minutes – about 100 times per day!\nIn Māori mythology the fantail was responsible for the presence of death in the world. Maui, thinking he could eradicate death by successfully passing through the goddess of death, Hine-nui-te-po, tried to enter the goddess’s sleeping body through the pathway of birth. The fantail, warned by Maui to be quiet, began laughing and woke Hine-nuite- po, who was so angry that she promptly killed Maui.\n\nDid you know?\nFantails use three methods to catch insects. The first, called hawking, is used where vegetation is open and the birds can see for long distances. Fantails use a perch to spot swarms of insects and then fly at the prey, snapping several insects at a time.\nThe second method that fantails use in denser vegetation is called flushing. The fantail flies around to disturb insects, flushing them out before eating them.\nFeeding associations are the third way fantails find food. Every tramper is familiar with this method, where the fantail follows another bird or animal to capture insects disturbed by their movements. Fantails frequently follow feeding silvereyes, whiteheads, parakeets and saddlebacks, as well as people.\n " family:@"Monarchidae" link:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/land-birds/fantail-piwakawaka/" category:@"endemic"],

     [Bird birdWithName:@"Tui" maoriname:@"Prosthemadera novaeseelandiae" image:[UIImage imageNamed:@"Tui_on_flax.jpg"] sound:@"tui2" description:@"Tūī are common throughout New Zealand in forests, towns and on off-shore islands. They are adaptable and are found not only in native forests, bush reserves and bush remnants but also in suburban areas, particularly in winter if there is a flowering gum about.\n      These attractive birds can often be heard singing their beautiful melodies long before they are spotted. If you are fortunate to glimpse one you will recognise them by their distinctive white tuft under their throat, which contrasts dramatically with the metallic blue-green sheen to their underlying black colour.\n\nTūī are unique (endemic) to New Zealand and belong to the honeyeater family, which means they feed mainly on nectar from flowers of native plants such as kōwhai, puriri, rewarewa, kahikatea, pohutukawa, rātā and flax. Occasionally they will eat insects too. Tūī are important pollinators of many native trees and will fly large distances, especially during winter for their favourite foods.\nTūī will live where there is a balance of ground cover, shrubs and trees. Tūī are quite aggressive, and will chase other tūī and other species (such as bellbird, silvereye and kereru) away from good food sources.\n\nAn ambassador for successful rejuvenation\nA good sign of a successful restoration programme, in areas of New Zealand, is the sound of the tūī warbling in surrounding shrubs. These clever birds are often confusing to the human ear as they mimic sounds such as the calls of the bellbird. They combine bell-like notes with harsh clicks, barks, cackles and wheezes.\n\nBreeding facts\nCourting takes place between September and October when they sing high up in the trees in the early morning and late afternoon. Display dives, where the bird will fly up in a sweeping arch and then dive at speed almost vertically, are also associated with breeding. Only females build nests, which are constructed from twigs, fine grasses and moss.\n\nWhere can tūī be found\nThe tūī can be found throughout the three main islands of New Zealand. The Chatham Islands have their own subspecies of tūī that differs from the mainland variety mostly in being larger." family:@"Meliphagidae/ Honeyeaters" link:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/land-birds/tui/" category:@"endemic"],
     [Bird birdWithName:@"Stitchbird" maoriname:@"Tauhou/Hihi" image:[UIImage imageNamed:@"Hihi_(Stitchbird)-1.jpg"] sound:@"Hihi_Stitchbird" description:@"The stitchbird/hihi (Notiomystis cincta) is one of New Zealand’s rarest birds.  A medium-sized forest species, hihi compete with tui and bellbirds for nectar, insects and small fruits.\nBut apart from diet, hihi share few qualities with tui and bellbird, which are members of the honeyeater family.  Recent DNA analysis has shown that hihi are in fact the sole representative of another bird family found only in New Zealand whose closest relatives may be the iconic wattlebirds that include kokako, saddleback and the extinct huia.\nHow to recognise hihi\n\nMale and female hihi look quite different.  He flaunts a flashy plumage of black head with white ‘ear’ tufts, bright yellow shoulder bars and breast bands and a white wing bar and has a mottled tan-grey-brown body.\nShe is more subdued with an olive-grey-brown body cover, white wing bars and small white ‘ear’ tufts.  They both have small cat-like whiskers around the beak and large bright eyes.\nHihi can be recognised by their posture of an upward tilted tail and strident call from which the name ‘stitchbird’ derives.  A 19th century ornithologist Sir Walter Buller described the call made by the male hihi as resembling the word ‘stitch’.  This call sounds a little like two stones being repeatedly stuck together.  Both males and females also have a range of warble-like calls and whistles.\n\nUnique characteristics\nUnlike most other birds, hihi build their nests in tree cavities.  The nest is complex with a stick base topped with a nest cup of finer twigs and lined with fern scales, lichen and spider web.\nHihi have a diverse and unusual mating system.  A female may breed with a single male or with several.  These arrangements can make determining the parentage of chicks a challenge.  Hihi are also the only birds known to sometimes mate face to face.\n\nHihi research\n    An active research programme with Massey and Auckland universities, as well as other institutes, has greatly increased our knowledge of hihi biology.\nHihi have been found to have a fascinating and complex mating system.  Males pair up with a female in their territory while also seeking to mate with other females in the neighbourhood.  To ensure the chicks are his, males need to produce large amounts of sperm to dilute that of other males.  And to avoid wasting this, the male has to assess exactly when a female is ready to breed.  In the days leading up to laying, when a female is weighed down with developing eggs, a number of males may chase her for hours at a time, all attempting to mate with her.\nResearch has also resulted in developing techniques for managing nesting behaviour, for example, managing nest mites, cross fostering and sexing of chicks and habitat suitability.\nManagement of the captive population at the Pukaha Mount Bruce National Wildlife Centre in eastern Wairarapa has also contributed to understanding the role of avian diseases in managing hihi populations.  Diseases such as Aspergillosis, a fungal infection of the respiratory tract, and Coccidiosis, an intestinal parasite, have been found to affect wild hihi survivial.\nCurrent research programmes include developing a technique to measure the size of the Little Barrier hihi population and assess its health and viability.  Another study, on Tiritiri Matangi, is looking at the effect of carotenoid availability on hihi health (carotenoids are used for the yellow colour in male hihi feathers and egg yolk, and are important for health).\n      \n\nWhere to find:  —Little Barrier, Tiritiri Matangi, Kapiti Islands, Kaori Wildlife Sanctuary (Zealandia)."  family:@"Notiomystis" link:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/land-birds/stitchbird/" category:@"endemic"],
     [Bird birdWithName:@"Silvereye" maoriname:@"Waxeye" image:[UIImage imageNamed:@"DSC09462.JPG"] sound:@"silvereye-song-22sy" description:@"The silvereye (Zosterops lateralis) – also known as the wax-eye, or sometimes white eye – is a small olive green forest bird with white rings around its eyes.\nThese friendly birds were self introduced in the 1800s and now have a wide distribution throughout New Zealand.\n They have made the forest their home and are now among the most common bird in suburbia too. The subtle calling of the flock as they move through the forest is pleasant music in an iPod-free forest.\nThe silvereye has a wide distribution throughout New Zealand. They can be found from sea level to above the tree line but they are not abundant in deep forest or open grassland.\nSlightly smaller than a sparrow, the silvereye is olive-green with a ring of white feathers around the eye. Males have slightly brighter plumage than females. They have a fine tapered bill and a brush tipped tongue like the tui and bellbird.\nSilvereye's mainly eat insects, fruit and nectar.\nThe silvereye was first recorded in New Zealand in 1832 and since there is no evidence that it was artificially introduced, it is classified as a native species. Its Māori name, tauhou, means stranger or more literally, new arrival." family:@"Zosteropidae" link:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/land-birds/silvereye-or-wax-eye/" category:@"endemic"],
     [Bird birdWithName:@"Bellbird" maoriname:@"Korimako" image:[UIImage imageNamed:@"Anthornis_melanura_-New_Zealand-8.jpg"] sound:@"bellbird-56" description:@"Most New Zealanders can easily recognise the bellbird by its melodious song, which Captain Cook described as sounding ‘like small bells exquisitely tuned’.\n      Well camouflaged, the bellbird is usually heard before it is seen. Females are dull olive-brown, with a slight blue sheen on the head and a pale yellow cheek stripe. Males are olive green, with a purplish head and black outer wing and tail feathers.\n\nWhere are they found?\n\nBellbirds are unique to New Zealand, occurring on the three main islands, many offshore islands and also the Auckland Islands. When Europeans arrived in New Zealand, bellbirds were common throughout the North and South Islands. Their numbers declined sharply during the 1860s in the North Island and 1880s in the South Island, about the time that ship rats and stoats arrived. For a time it was thought they might vanish from the mainland. Their numbers recovered somewhat from about 1940 onwards, but they are almost completely absent on the mainland north of Hamilton, and are still rare in parts of Wellington, Wairarapa and much of inland Canterbury and Otago.\n      Bellbirds live in native forest (including mixed podocarp-hardwood and beech forest) and regenerating forest, especially where there is diverse or dense vegetation. They can be found close to the coast or in vegetation up to about 1200 metres. In the South Island they have been found inhabiting plantations of eucalypts, pines or willows. They can be spotted in urban areas, especially if there is bush nearby.\nTypically they require forest and scrub habitats, reasonable cover and good local food sources during the breeding season, since they do not travel far from the nest. However, outside the breeding season they may travel many kilometres to feed, especially males.\n\nDid you know?\nJust as people from different parts of New Zealand can have noticeable regional accents (think of the Southlander’s rolling ‘r’), bellbirds also sing with regional ‘dialects’. Bellbird songs vary enormously from one place to another, even over short distances. For example, a study in Christchurch found that birds in three patches of bush on the Port Hills all had different songs. There is also anecdotal evidence that male and female bellbirds sing different songs, at least during some parts of the year. The song of juveniles is not fully developed straight away so an expert can distinguish their songs from adult songs.\n\nBellbird facts\nBellbirds are generalist feeders; they eat nectar, fruit and insects, with insects being particularly important to females and chicks during the breeding season. They often feed in tree canopies but do come down to feed on flax and native fuchsia nectar.\nAs nectar-feeders (or ‘honeyeaters’ as scientists call them), bellbirds are important pollinators of many native plant species, such as mistletoe, fuchsia and kowhai.\nThe breeding season is approximately September through to February. Bellbirds tend to nest in trees, and prefer trees with dense foliage for cover. Bellbirds are strongly territorial during the breeding season.\nBellbirds are known to mate with the same partner year after year, and the pair maintains the same breeding territory each year. The female makes the nest, lays 3 to 5 eggs, and incubates the clutch. Both parents feed the chicks, which fledge after 14 days. A pair can raise two broods in a season.\nBellbird song comprises three distinct sounds resembling the chiming of bells. They sing throughout the day, but more so in the early morning and late evening. The alarm call is a series of loud, rapidly repeated, harsh staccato notes.\n" family:@"Meliphagidae/ Honeyeaters" link:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/land-birds/bellbird-korimako/facts/" category:@"endemic"],
     [Bird birdWithName:@"Kiwi" maoriname:@"Roroa/ Apteryx haastii" image:[UIImage imageNamed:@"GreatSpottedKiwi_p10164doc.jpg"] sound:@"is_kiwi" description:@"The kiwi is the national icon of New Zealand and the unofficial national emblem.\nNew Zealanders have been called ""Kiwis"" since the nickname was bestowed by Australian soldiers in the First World War.\nToday a lot of dedicated people help to prevent kiwi from becoming extinct.\n\nThe kiwi is a curious bird: it cannot fly, has loose, hair-like feathers, strong legs and no tail. Mostly nocturnal, they are most commonly forest dwellers, making daytime dens and nests in burrows, hollow logs or under dense vegetation. Kiwi are the only bird to have nostrils at the end of its very long bill which is used to probe in the ground, sniffing out invertebrates to eat, along with some fallen fruit. It also has one of the largest egg-to-body weight ratios of any bird - the egg averages 15 per cent of the female's body weight (compared to two per cent for the ostrich).\nAdult kiwi usually mate for life, and are strongly territorial. Females are larger than males (up to 3.3 kg and 45 cm). Depending on the species, the male kiwi does most of the egg incubation, which is usually one clutch of one egg per year from June to December. Chicks hatch fully feathered after a long incubation of 70-85 days, emerge from the nest to feed at about five days old and are never fed by their parents. Juveniles grow slowly, taking three to five years to reach adult size.\nKiwi are long-lived, and depending on the species live for between 25 and 50 years.\n\nThe kiwi is related to a group of birds called ratites. The closest relatives to kiwi today are emus and cassowaries in Australia, but also the now-extinct moa of New Zealand. There are five species of kiwi:\n      Brown kiwi (Apteryx mantelli)\n      Rowi (Apteryx rowi)\n      Tokoeka (Apteryx australis)\n      Great spotted kiwi or roroa (Apteryx haastii)\n      Little spotted kiwi (Apteryx owenii)\nThe brown kiwi and tokoeka are further divided into four geographically and genetically distinct forms: the Northland, Coromandel, western and the eastern brown kiwi; and the Haast tokoeka, the northern Fiordland tokoeka, the southern Fiordland tokoeka and the Stewart Island tokoeka.\n\nStatus\n\nAll kiwi species are threatened with extinction, but to varying degrees. The rowi and the Haast tokoeka are our most threatened kiwi, due to their small population size and limited number of populations. The brown kiwi, great spotted kiwi, and the Fiordland and Stewart Island forms of tokoeka are “nationally vulnerable”, the third highest threat ranking in the New Zealand Threat Classification System; and the little spotted kiwi is classified as “at risk (recovering)”.\n\nread the long story here\nhttp://www.teara.govt.nz/en/kiwi/page-1" family:@"Ratites" link:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/land-birds/kiwi/facts/" category:@"endemic"],
     [Bird birdWithName:@"Kea" maoriname:@"Nestor notabilis" image:[UIImage imageNamed:@"800px-Nestor_notabilis_-Fiordland_National_Park-8a.jpg"] sound:@"kea2" description:@"Kea is rated as one of the most intelligent birds in the world.\nIf you are a frequent visitor to or live in an alpine environment you will know the kea well. Raucous cries of ""keeaa"" often give away the presence of these highly social and inquisitive birds. However, their endearing and mischievous behaviour can cause conflict with people.\n\nKea (Nestor  notabilis) are an endemic parrot of the South Island's high country. Although kea are seen in reasonable numbers throughout the South Island, the size of the wild population is unknown - but is estimated at between 1,000 and 5,000 birds.\nTo survive in the harsh alpine environment kea have become inquisitive and nomadic social birds - characteristics which help kea to find and utilise new food sources. Their inquisitive natures often cause kea to congregate around novel objects and their strong beaks have enormous manipulative power.\nKea are a protected species.\nKea grow up to 50 cm long and although mostly vegetarian, also enjoy grubs and insects.\nThe kea is related to the forest kaka (Nestor meridionalis) and is thought to have developed its own special characteristics during the last great ice age by using its unusual powers of curiosity in its search for food in a harsh landscape.\nNests are usually found among boulders in high altitude forest where the birds lay between two and four eggs during the breeding season from July and January." family:@"Psittacidae" link:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/land-birds/kea/" category:@"endemic"],
     [Bird birdWithName:@"Wood Pigeon" maoriname:@"Kererū/ Hemiphaga novaeseelandiae" image:[UIImage imageNamed:@"New_Zealand_Pigeon_Southstar_02.jpg"] sound:@"kereru" description:@"New Zealand's native pigeon, also known as kererū, kūkū and kūkupa and wood pigeon, is the only disperser of large fruits, such as those of karaka and taraire, we have. The disappearance of the kererū would be a disaster for the regeneration of our native forests.\n\nThe kererū is a large bird with irridescent green and bronze feathers on its head and a smart white vest. The noisy beat of its wings is a distinctive sound in our forests. The pigeon is found in most lowland native forests of the North, South and Stewart/Rakiura islands and many of their neighbouring islands.There are two species of native pigeon, the New Zealand pigeon (Hemiphaga novaeseelandiae) known to the Maori as kererū, or in Northland as kūkū or kūkupa, and the Chatham Islands pigeon (Hemiphaga chathamensis) or parea.\n\nThe parea is found mainly in the south-west of Chatham Island. While there are only about 500 parea left, the species has made a remarkable recovery over the past 20 years,  due to habitat protection and predator control.\nTwo other kinds of native pigeon became extinct on Raoul Island and Norfolk Island last century, probably due to hunting and predation\nSince the extinction of the moa, the native pigeon is now the only seed disperser with a bill big enough to swallow large fruit, such as those of karaka, tawa and taraire.\nIt also eats leaves, buds and flowers, the relative amounts varying seasonally and regionally, e.g. in Northland the birds eat mostly fruit.\nKererū are large birds and can measure up to 51 cm from tail to beak, and weigh about 650g.\nLong-lived birds, they breed slowly. Key breeding signals are spectacular display flights performed mainly by territorial males. They nest mainly in spring/early summer producing only one egg per nest, which the parents take turns to look after during the 28-day incubation period.\nThe chick grows rapidly, leaving the nest when about 40 days old. It is fed pigeon milk, a protein-rich milky secretion from the walls of the parents' crops, mixed with fruit pulp.  When much fruit is available, some pairs of kererū will have a large chick in one nest and be incubating an egg in another nearby. Fledglings spend about two weeks with their parents before becoming fully independent, but have remained with their parents during autumn and winter in some cases." family:@"Pigeons and Doves (Columbidae)" link:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/nz-pigeon-kereru/facts/" category:@"endemic"],
     [Bird birdWithName:@"Morepork" maoriname:@"Ruru/Ninox novaeseelandiae" image:[UIImage imageNamed:@"MoreporkMaunga.jpg"] sound:@"morepork" description:@"The morepork (Ninox novaeseelandiae) is New Zealand’s only surviving native owl. Often heard in the forest at dusk and throughout the night, the morepork is known for its haunting, melancholic call. Its Maori name, ruru, reflects this call. The much larger laughing owl became extinct in the 20th century. The German or little owl is a smaller species often found on open and lightly wooded farmland. It was introduced to New Zealand between 1906 and 1910 to try to control smaller introduced birds.\nMorepork are commonly found in forests throughout mainland New Zealand and on offshore islands. They are less common within the drier open regions of Canterbury and Otago. They are classified as not threatened.\n\nPhysical description\nMorepork are speckled brown with yellow eyes set in a dark facial mask. They have a short tail.\nThe females are bigger than the males.\nHead to tail they measure around 29cm and the average weight is about 175g.\nThey have acute hearing and are sensitive to light.\nThey can turn their head through 270 degrees.\n\nNocturnal birds of prey\nMorepork are nocturnal, hunting at night for large invertebrates including beetles, weta, moths and spiders. They will also take small birds, rats and mice. They fly silently as they have soft fringes on the edge of the wing feathers. They catch prey using large sharp talons or beak. By day they roost in the cavities of trees or in thick vegetation. If they are visible during the day they can get mobbed by other birds and are forced to move.\n\nNesting and breeding\nMorepork nest in tree cavities, in clumps of epiphytes or among rocks and roots.\nThe female can lay up to three eggs, but generally two, usually between September and November.\nThe female alone incubates the eggs for about 20 to 30 days during which time the male brings in food for her.\nOnce the chicks hatch, the female stays mainly on the nest until the owlets are fully feathered.\nThey fledge around 37-42 days.\nDepending on food supply often only one chick survives and the other may be eaten.\n\nMaori tradition\nIn Maori tradition the morepork was seen as a watchful guardian. It belonged to the spirit world as it is a bird of the night. Although the more-pork or ruru call was thought to be a good sign, the high pitched, piercing, ‘yelp’ call was thought to be an ominous forewarning of bad news or events." family:@"?" link:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/morepork-ruru/" category:@"endemic"],
     [Bird birdWithName:@"Moa" maoriname:@"Dinornis novaezealandiae" image:[UIImage imageNamed:@"823px-Dinornis1387.jpg"] sound:@"kea2" description:@"Richard Owen, who became director of London’s Museum of Natural History, was the first to recognise that a bone fragment he was shown in 1839 came from a large bird. When later sent collections of bird bones, he managed to reconstruct moa skeletons. In this photograph, published in 1879, he stands next to the largest of all moa, Dinornis maximus (now D. novaezealandiae), while holding the first bone fragment he had examined 40 years earlier. Richard Owen, Memoirs on the extinct wingless birds of New Zealand. Vol. 2. London: John van Voorst, 1879, plate XCVII" family:@"Ratites" link:@"http://www.lib.utexas.edu/books/nzbirds/html/txu-oclc-7314815-2-31-p-097.html" category:@"endemic"],
     [Bird birdWithName:@"Rifleman" maoriname:@"Acanthisitta chloris" image:[UIImage imageNamed:@"Rifleman_Acanthisitta_chloris.jpg"] sound:@"Rifleman" description:@"A bird" family:@"Acanthisittidae (New Zealand Wrens)" link:@"www.doc.govt.nz/" category:@"endemic"],
     [Bird birdWithName:@"Kakariki" maoriname:@"Cyanoramphus novaezelandiae" image:[UIImage imageNamed:@"Cyanoramphus_novaezelandiae_-Kapiti_Island,_New_Zealand-8.jpg"] sound:@"kakariki" description:@"A parrot-like bird" family:@"Psittacidae" link:@"www.doc.govt.nz/" category:@"endemic"],
     [Bird birdWithName:@"Grey warbler" maoriname:@"Riroriro" image:[UIImage imageNamed:@"GreyWarbler_Gerygone1888.jpg"] sound:@"cockatiel" description:@"The grey warbler/riroriro (Gerygone igata) is a relatively inconspicuous grey bird that flits about the canopy of the forest but its call permeates the forest and takes the edge off a hard uphill slog for any attentive tramper.\nThese diminutive insectivorous birds busy themselves along branches seeking out small invertebrates.\nGrey warbler was the surprise recipient of the title of New Zealand's best-loved bird in 2007." family:@"?" link:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/grey-warbler-riroriro/" category:@"endemic"],
     [Bird birdWithName:@"Tomtit" maoriname:@"Miromiro" image:[UIImage imageNamed:@"A_Tomtit.jpg"] sound:@"cockatiel" description:@"The New Zealand tomtit (Petroica macrocephala) looks similar to a robin. They are a small bird with a large head, a short bill and tail, and live in forest and scrub.\nThe Māori name of the North Island Tomtit is miromiro, while the South Island Tomtit is known as ngirungiru.\nThere are five subspecies of tomtit/miromiro, each restricted to their own specific island or island group: North Island, South Island, the Snares Islands, the Chatham Islands and the Auckland Islands." family:@"?" link:@"http://www.doc.govt.nz/conservation/native-animals/birds/birds-a-z/tomtit-miromiro/" category:@"introduced"],
     [Bird birdWithName:@"Chaffinch" maoriname:@"Fringilla coelebs" image:[UIImage imageNamed:@"Chaffinch_2.jpg"] sound:@"cockatiel" description:@"An endemic bird" family:@"Fringillidae" link:@"www.doc.govt.nz/" category:@"introduced"],
    [Bird birdWithName:@"Blackbird" maoriname:@"Turdus merula" image:[UIImage imageNamed:@"Blackbird.jpg"] sound:@"blackbird" description:@"a black bird" family:@"Turdidae" link:@"www.doc.govt.nz/" category:@"introduced"],
     [Bird birdWithName:@"Paradise Duck" maoriname:@"Tadorna variegata" image:[UIImage imageNamed:@"1024px-History_of_the_birds_of_NZ_1st_ed_p240_paradiseDuck.jpg"] sound:@"bellbird-56" description:@"A common duck bird. Sexually dimorph, male and female look quite different."  family:@"Anatidae" link:@"www.doc.govt.nz/" category:@"introduced"],
     
    [Bird birdWithName:@"Banded dotterel" maoriname:@"Charadricus" image:[UIImage imageNamed:@"Charadrius_bicinctus_breeding_-_Ralphs_Bay.jpg"] sound:@"bellbird-56" description:@"A common bird"  family:@"Charadriidae" link:@"www.doc.govt.nz/" category:@"introduced"],
     [Bird birdWithName:@"Song thrush" maoriname:@"Turdus philomelos" image:[UIImage imageNamed:@"Thrush_song_06-03_SCOT.jpg"] sound:@"bellbird-56" description:@"A common bird"  family:@"Turdidae" link:@"www.doc.govt.nz/" category:@"introduced"],
     [Bird birdWithName:@"Australian magpie" maoriname:@"Gymnorhina tibicen" image:[UIImage imageNamed:@"1008px-G_tibicen_dorsalis_gnangarra.jpg"] sound:@"Australian-Magpie" description:@"A common bird"  family:@"Charadriidae" link:@"www.doc.govt.nz/" category:@"introduced"],
     [Bird birdWithName:@"Cockatiel" maoriname:@"Psittacus hollandicus" image:[UIImage imageNamed:@"Cockatiel.jpg"] sound:@"cockatiel" description:@"An introduced bird, captivity" family:@"Cacatuidae" link:@"www.doc.govt.nz/" category:@"introduced"]
     ]];    
    // Initialize the filteredBirdsArray with a capacity equal to the birdArray's capacity
    self.filteredBirdsArray = [NSMutableArray arrayWithCapacity:[[self birds] count]];
   }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //self.birds = nil;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
     // first check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [filteredBirdsArray count];
    } else {
        return [[self birds] count];
    }
}

 
// provide custom styling for cell background using 3 images
- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self tableView:[self tableView] numberOfRowsInSection:0];
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    if (rowIndex == 0) {
        background = [UIImage imageNamed:@"cell_top.png"];
    } else if (rowIndex == rowCount - 1) {
        background = [UIImage imageNamed:@"cell_bottom.png"];
    } else {
        background = [UIImage imageNamed:@"cell_middle.png"];
    }
    
    return background;
}


 
 

-(BirdTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"birdTableCell";
    BirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil ) {
        cell = [[BirdTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Create a new Bird Object
    Bird *bird = nil;
   
    // Check to see whether the normal table or search results table is being displayed and set the Bird object from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        bird = [filteredBirdsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [[filteredBirdsArray objectAtIndex:indexPath.row] name];
        [[cell imageView] setImage:[bird image]];
        
    } else {
        bird = [birds objectAtIndex:indexPath.row];

    }
    // Configure the cell
    // Assign our own background image for the cell
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    // Set cell contents from bird array
    [[cell nameLabel] setText:[bird name]];
    [[cell othernameLabel] setText:[bird maoriname]];
    [[cell imageView] setImage:[bird image]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredBirdsArray removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[cd] %@",searchText];
    NSArray *tempArray = [birds filteredArrayUsingPredicate:predicate];
    if (![scope isEqualToString:@"All"]) {
        // Further filter the array with the scope
        NSPredicate *scopePredicate = [NSPredicate predicateWithFormat:@"SELF.category contains[cd] %@",scope];
        tempArray = [tempArray filteredArrayUsingPredicate:scopePredicate];
    }
    filteredBirdsArray = [NSMutableArray arrayWithArray:tempArray];
    //if not using Scope use this filter
    //filteredBirdsArray = [NSMutableArray arrayWithArray:[birds filteredArrayUsingPredicate:predicate]];
}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Perform segue to bird detail
    [self performSegueWithIdentifier:@"ShowBirdDetails" sender:tableView];
}

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowBirdDetails"]) {
        BirdDetailViewController *vc = [segue destinationViewController];
        // In order to manipulate the destination view controller, another check on which table (search or normal) is displayed is needed
        if(sender == self.searchDisplayController.searchResultsTableView) {
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            NSString *destinationTitle = [[filteredBirdsArray objectAtIndex:[indexPath row]] name];
            [vc setTitle:destinationTitle];
            Bird *destinationBird = nil;
            destinationBird = [filteredBirdsArray objectAtIndex:indexPath.row];
            //destinationBird = [[filteredBirdsArray objectAtIndex:[indexPath row]] bird ];
            [vc setBird:destinationBird];
        }
        else {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            NSString *destinationTitle = [[birds objectAtIndex:[indexPath row]] name];
            [vc setTitle:destinationTitle];
            
            Bird *destinationBird = nil;
            destinationBird = [birds objectAtIndex:indexPath.row];
            [vc setBird:destinationBird];
        }
        
    }
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
    [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
/*
- (IBAction)gotoSearch:(UIBarButtonItem *)sender {
    // Hide the search bar until user scrolls up
    
    CGRect newBounds = self.tableView.bounds;
    newBounds.origin.y = newBounds.origin.y + birdSearchBar.bounds.size.height;
    self.tableView.bounds = newBounds;
 
}
 */
@end
