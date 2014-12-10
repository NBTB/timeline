package
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TextEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.Font;
	import Timeline.Timeline;
	import Timeline.TimelineItem;
	import Timeline.Slider;
	import Timeline.ProgressBar;
	
	/**
	 * ...
	 * @author Tim
	 */
	public class Main extends Sprite 
	{
		//{ region Constants
		
		// Constant that defines the URL of the XML database.
		public static const XMLDATA:String = "data/database.xml";

		//Embedded font linkage and definitions
		[Embed(source = "../bin/data/Lora-Regular.ttf", fontWeight = "Regular", fontFamily = "Lora", fontName = "Lora", mimeType = "application/x-font", embedAsCFF = "false", unicodeRange = "U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E,U+00A1-U+00A1,U+00A3-U+00A3,U+00A9-U+00A9,U+00AE-U+00AE,U+00B0-U+00B0,U+00BC-U+00BE,U+00BF-U+00BF,U+00C0-U+00FF,U+2013-U+2014,U+2018-U+2019,U+201C-U+201D,U+2022-U+2023,U+2120-U+2120,U+2122-U+2122")]
		private static const serifFont:Class;
		
		[Embed(source = "../bin/data/Carnevalee.ttf", fontWeight = "Regular", fontFamily = "Carn", fontName = "Carn", mimeType = "application/x-font", embedAsCFF = "false", unicodeRange = "U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E,U+00A1-U+00A1,U+00A3-U+00A3,U+00A9-U+00A9,U+00AE-U+00AE,U+00B0-U+00B0,U+00BC-U+00BE,U+00BF-U+00BF,U+00C0-U+00FF,U+2013-U+2014,U+2018-U+2019,U+201C-U+201D,U+2022-U+2023,U+2120-U+2120,U+2122-U+2122")]
		private static const civilWarFont:Class;

		Font.registerFont(serifFont);
		Font.registerFont(civilWarFont);

        public static var serif_tf:TextFormat = new TextFormat("Lora", 30,0x1a1b1f);
		public static var timeline_date_tf:TextFormat = new TextFormat("Lora", 12,0x444444);
		public static var title_tf:TextFormat = new TextFormat("Carn",36,0x1a1b1f);
		public static var subtle_tf:TextFormat = new TextFormat("Lora",25,0x786649);
		public static var subtler_tf:TextFormat = new TextFormat("Lora",25,0xa9997f);
		//} endregion
		
		public var timelineItemList:Vector.<TimelineItem>; //stores all the events from our database in sorted order
		public var currentItemList:Vector.<TimelineItem>; //stores the currently shown events
		private var currentItems:MovieClip;
		private var loaded:int = 0; //Fake loading progress since we don't use images anymore, but we still need time for AS3 to process everything
		
		//{ region UI Elements
		
		private var title:MovieClip;
		private var background:MovieClip;
		private var political:FilterButton;
		private var battles:FilterButton;
		private var artist:FilterButton;
		private var art:FilterButton;
		private var loady:ProgressBar;
		public var loader:Loader;

		public static var zoomSlider:Slider;
		private var zoomInbox:TextField;
		private var zoomOutbox:TextField;
		
		public var timeline:Timeline;
		
		//} endregion
		
		
		private var beginDate:int;
		private var endDate:int;
		private var MINDATE:int = 1810;
		private var MAXDATE:int = 1895;
		private var lineStart:int = 100;
		private var lineEnd:int = 650;
		private var lineHeight:int = 500;
	
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			loady = new ProgressBar(100,30);
			loady.x = (stage.stageWidth / 2) - (loady.width / 2);
			loady.y = (stage.stageHeight / 2) - (loady.height / 2);
			loady.draw(0);
			addChild(loady);

			beginDate = 1860;
			endDate = 1866;

			addEventListener(Event.ENTER_FRAME, loadProgress);
			loader = new Loader();

		}

		public function loadProgress(e:Event = null):void {
			if(loaded < 100) {
				loaded++;
				loady.draw(loaded / 100);
			}
			else {
				removeEventListener(Event.ENTER_FRAME, loadProgress);
				loadNext();
			}
			
		}
		
		public function loadNext(e:Event = null):void {
			trace("loading XML now...");
			var xmlloader:URLLoader = new URLLoader();
			xmlloader.addEventListener(Event.COMPLETE, parseXML);
			xmlloader.load(new URLRequest(XMLDATA));
		}
		
		//pretty much copied verbatim -- those namespaces are just too messy to deal with (ditto for the xml file itself)
		public function parseXML(e:Event):void {
			var xml:XML = new XML(e.target.data);
			xml.ignoreWhitespace=true;
			var ss:Namespace = new Namespace("urn:schemas-microsoft-com:office:spreadsheet");
			
			trace("xml reading");
			
			timelineItemList = new Vector.<TimelineItem>();
			for(var i:int=0; i<xml.ss::Worksheet..ss::Table.children().length(); i++)
			{
				var rName:String = xml.ss::Worksheet..ss::Table.children()[i].name();

				if(rName == "urn:schemas-microsoft-com:office:spreadsheet::Row")
				{
					var tEvent:TimelineItem = new TimelineItem();
					
					tEvent.year = xml.ss::Worksheet..ss::Table.children()[i].children()[0].children()[0];
					if (tEvent.year != 0)
					{
						tEvent.month = xml.ss::Worksheet..ss::Table.children()[i].children()[1].children()[0];
						tEvent.day = xml.ss::Worksheet..ss::Table.children()[i].children()[2].children()[0];
						tEvent.type = xml.ss::Worksheet..ss::Table.children()[i].children()[3].children()[0];
						tEvent.title = xml.ss::Worksheet..ss::Table.children()[i].children()[4].children()[0];
						tEvent.url = xml.ss::Worksheet..ss::Table.children()[i].children()[5].children()[0];
						tEvent.description = xml.ss::Worksheet..ss::Table.children()[i].children()[6].children()[0];
						
						if (tEvent.type == "Battle")
						{
							tEvent.victor = xml.ss::Worksheet..ss::Table.children()[i].children()[7].children()[0];	
							tEvent.importance = xml.ss::Worksheet..ss::Table.children()[i].children()[8].children()[0];	
							tEvent.uStrength = xml.ss::Worksheet..ss::Table.children()[i].children()[9].children()[0];	
							tEvent.cStrength = xml.ss::Worksheet..ss::Table.children()[i].children()[10].children()[0];	
							tEvent.uCasualties = xml.ss::Worksheet..ss::Table.children()[i].children()[11].children()[0];	
							tEvent.cCasualties = xml.ss::Worksheet..ss::Table.children()[i].children()[12].children()[0];	
						}
						else if (tEvent.type == "Art")
						{
							tEvent.artist = xml.ss::Worksheet..ss::Table.children()[i].children()[7].children()[0];
							tEvent.imageLoc = xml.ss::Worksheet..ss::Table.children()[i].children()[8].children()[0];						
						}
						
						timelineItemList.push(tEvent);
					}
				}
			}
			
			for (var j:int = 0; j < timelineItemList.length; j++) {
				timelineItemList[j].setUp();
			}
			//timelineItemList.sort(TimelineItem.sortItems);
			
			trace("xml done reading");
			populateUI();
		}
		private function populateUI():void {		
			timeline = new Timeline(0, 320, stage.stageWidth, 350, timelineItemList);
			addChild(timeline);

			trace("populateUI");

			var mainTitle:TextField = new TextField();
			mainTitle.embedFonts = true;
			mainTitle.defaultTextFormat = title_tf;
			mainTitle.x = 15;
			mainTitle.y = 15;
			mainTitle.width = 400;
			mainTitle.text = "The Night Before The Battle";
			addChild(mainTitle);

			var secondaryTitle:TextField = new TextField();
			secondaryTitle.embedFonts = true;
			title_tf.size = 30;
			secondaryTitle.defaultTextFormat = title_tf;
			secondaryTitle.x = 100;
			secondaryTitle.y = 60;
			secondaryTitle.width = 400;
			secondaryTitle.text = "Civil War Timeline";
			addChild(secondaryTitle);

			var tempFormat:TextFormat = new TextFormat();
			tempFormat.color = 0x1a1b1f;
			tempFormat.size = 20;

			var keyTitle:TextField = new TextField();
			keyTitle.embedFonts = true;
			keyTitle.selectable = false;
			timeline_date_tf.size = 25;
			timeline_date_tf.color = 0x786649;
			keyTitle.defaultTextFormat = timeline_date_tf;
			keyTitle.x = 30;
			keyTitle.y = 230;
			keyTitle.rotation = -90;
			keyTitle.text = "Key";
			keyTitle.multiline = true;
			keyTitle.autoSize = "left";
			keyTitle.wordWrap = true;
			addChild(keyTitle);

			battles = new FilterButton("Battle", "Battles of the Civil War", 0xa66249);
			battles.x = 85;
			battles.y = 130;
			battles.addEventListener(MouseEvent.CLICK, setFilter);
			this.addChild(battles);

			political = new FilterButton("Political", "Political Front", 0x4971a6);
			political.x = battles.x;
			political.y = battles.y + 45;
			political.addEventListener(MouseEvent.CLICK, setFilter);
			this.addChild(political);

			artist = new FilterButton("Artist", "Life of James Henry Beard", 0x8e8b32);
			artist.x = battles.x;
			artist.y = political.y + 45;
			artist.addEventListener(MouseEvent.CLICK, setFilter);
			this.addChild(artist);

			art = new FilterButton("Art", "Art of the Civil War Era", 0x5f7936);
			art.x = battles.x;
			art.y = artist.y + 45;
			art.addEventListener(MouseEvent.CLICK, setFilter);
			this.addChild(art);

			zoomSlider = new Slider(5);
			zoomSlider.x = 365;
			zoomSlider.y = 133;
			//Flip the Slider because in Timeline.as, a higher targetZoom means we're zooming out
			//Great job, whoever coded it like that. Sound logic.
			zoomSlider.rotation = 90;
			addChild(zoomSlider);
			zoomInbox = new TextField();
			zoomInbox.text ="+";
			zoomInbox.x = zoomSlider.x - 16;
			zoomInbox.y = zoomSlider.y - 25;
			zoomInbox.height = 25;
			zoomInbox.width = 40;
			//zoomInbox.addEventListener(MouseEvent.CLICK, timeline.zoomIn);
			zoomInbox.setTextFormat(tempFormat);
			zoomInbox.selectable = false;
			addChild(zoomInbox);
			
			zoomOutbox = new TextField();
			zoomOutbox.text ="-";
			zoomOutbox.x = zoomSlider.x - 13;
			zoomOutbox.y = zoomSlider.y + zoomSlider.height - 5;
			zoomOutbox.height = 25;
			zoomOutbox.width = 20;
			//zoomOutbox.addEventListener(MouseEvent.CLICK, timeline.zoomOut);
			zoomOutbox.setTextFormat(tempFormat);
			zoomOutbox.selectable = false;
			addChild(zoomOutbox);
			
			setFilter();
			//Show info box for the first timeline item when the program starts
			timeline.Field.items[0].dispatchEvent(new MouseEvent(MouseEvent.CLICK, true, false));
			removeChild(loady);
		}
				
		private function setFilter(e:Event = null):void {
			var tags:Array = new Array();
			if (political.Selected) tags.push(political.Tag);
			if (battles.Selected) tags.push(battles.Tag);
			if (artist.Selected) tags.push(artist.Tag);
			if (art.Selected) tags.push(art.Tag);
			
			timeline.Field.filter(tags);
			timeline.Field.stagger(timeline.StartDate, timeline.EndDate, timeline.TargetZoom);
		}
	}
	
}