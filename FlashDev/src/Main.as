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
		
		// Constants for icon assets. 
		// NOTE: in order for the icon to be loaded, you must also add the constant to the IMAGES array below.
		public static const TITLE:String = "data/title.png";
		
		// Constant that defines an array of images to load in sequence.
		public static const IMAGES:Array = [TITLE];

		//Embedded font linkage and definitions
		[Embed(source = "../bin/data/Lora-Regular.ttf", fontWeight = "Regular", fontName = "Lora", mimeType = "application/x-font", embedAsCFF = "false", unicodeRange = "U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E,U+00A1-U+00A1,U+00A3-U+00A3,U+00A9-U+00A9,U+00AE-U+00AE,U+00B0-U+00B0,U+00BC-U+00BE,U+00BF-U+00BF,U+00C0-U+00FF,U+2013-U+2014,U+2018-U+2019,U+201C-U+201D,U+2022-U+2023,U+2120-U+2120,U+2122-U+2122")]
		private static const serifFont:Class;
		Font.registerFont(serifFont);
        public static var serif_tf:TextFormat = new TextFormat( "Lora", 30,0x777777 );
		public static var timeline_date_tf:TextFormat = new TextFormat( "Lora", 12,0x444444 );
		//} endregion
		
		public var timelineItemList:Vector.<TimelineItem>;		//stores all the events from our database in sorted order
		public var currentItemList:Vector.<TimelineItem>;		//stores the currently shown events
		private var currentItems:MovieClip;
		public var iconArray:Vector.<Bitmap>;						//stores all the icons
		private var loaded:int = 0;           //keeps track of which images needs to be loaded next.
		
		//{ region UI Elements
		
		private var title:MovieClip;
		private var background:MovieClip;
		private var political:FilterButton;
		private var battles:FilterButton;
		private var artist:FilterButton;
		private var art:FilterButton;
		private var loady:ProgressBar;
		public var loader:Loader;
		
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
	
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			
			loady = new ProgressBar(100,30);
			loady.x = (stage.stageWidth / 2) - (loady.width / 2);
			loady.y = (stage.stageHeight / 2) - (loady.height / 2);
			loady.draw(0);
			addChild(loady);
			
			iconArray = new Vector.<Bitmap>();
			beginDate = 1860;
			endDate = 1866;
			
			loader = new Loader();
			loadNext();
		}
		
		public function loadNext(e:Event = null):void {
			//The first time this is called, e is null, every other time, e.target is a Loader that just finished.
			if(e != null) { iconArray.push(e.target.loader.content); }
			
			
			//if there are still images to load, load the next one.
			if (loaded < IMAGES.length)
			{
				trace("loading image #" + loaded + " now...");
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadNext);
				loader.load(new URLRequest(IMAGES[loaded]));
				loaded++;
				loady.draw(loaded / IMAGES.length);
				//TODO update loading graphic
			}
			//otherwise, load the xml file.
			else
			{
				trace("loading XML now...");
				var xmlloader:URLLoader = new URLLoader();
				xmlloader.addEventListener(Event.COMPLETE, parseXML);
				xmlloader.load(new URLRequest(XMLDATA));
				loaded++;
				
				//TODO update loading graphic
			}
			
		}
		
		//pretty much copied verbatim -- those namespaces are just too messy to deal with (ditto for the xml file itself)
		public function parseXML(e:Event):void
		{
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
						tEvent.shortDes = xml.ss::Worksheet..ss::Table.children()[i].children()[5].children()[0];
						tEvent.fullDes = xml.ss::Worksheet..ss::Table.children()[i].children()[6].children()[0];
						
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
				timelineItemList[j].setUp(iconArray);
			}
			//timelineItemList.sort(TimelineItem.sortItems);
			
			trace("xml done reading");
			populateUI();
		}
		private function populateUI():void
		{		
			timeline = new Timeline(20, 600, 1240, 350, timelineItemList, iconArray);
			addChild(timeline);
			
			trace("populateUI");
			
			title = new MovieClip();
			title.addChild(new Bitmap((iconArray[0]).bitmapData.clone()));
			title.x = 15;
			title.y = 15;
			this.addChild(title);
			
			var keyTitle:TextField = new TextField();
			keyTitle.x = 15;
			keyTitle.y = 50;
			keyTitle.text = "Key";
			keyTitle.multiline = true;
			keyTitle.autoSize = "left";
			keyTitle.wordWrap = true;
			serif_tf.color = 0x777777;
			keyTitle.setTextFormat(serif_tf);
			addChild(keyTitle);
			
			political = new FilterButton("Political", "Political Front", 0x4971a6);
			political.x = 45;
			political.y = 125;
			political.addEventListener(MouseEvent.CLICK, setFilter);
			this.addChild(political);
			
			battles = new FilterButton("Battle", "Battles of the Civil War", 0xa66249);
			battles.x = political.x;
			battles.y = political.y + 55;
			battles.addEventListener(MouseEvent.CLICK, setFilter);
			this.addChild(battles);
			
			artist = new FilterButton("Artist", "Life of James Henry Beard", 0x8e8b32);
			artist.x = political.x;
			artist.y = battles.y + 55;
			artist.addEventListener(MouseEvent.CLICK, setFilter);
			this.addChild(artist);
			
			art = new FilterButton("Art", "Art of the Civil War Era", 0x5f7936);
			art.x = political.x;
			art.y = artist.y + 55;
			art.addEventListener(MouseEvent.CLICK, setFilter);
			this.addChild(art);
			
			var tempFormat = new TextFormat();
			tempFormat.color = 0x444444;
			tempFormat.size = 32;
			
			var zoomSlider:Slider = new Slider(7);
			zoomSlider.x = 200;
			zoomSlider.y = 500;
			//Flip the Slider because in Timeline.as, a higher targetZoom means we're zooming out
			//Great job, whoever coded it like that. Sound logic.
			zoomSlider.rotation = 180;
			addChild(zoomSlider);
			zoomInbox = new TextField();
			zoomInbox.text ="+";
			zoomInbox.x = zoomSlider.x + 5;
			zoomInbox.y = zoomSlider.y - (zoomSlider.height / 2);
			zoomInbox.height = 75;
			zoomInbox.width = 40;
			//zoomInbox.addEventListener(MouseEvent.CLICK, timeline.zoomIn);
			zoomInbox.setTextFormat(tempFormat);
			zoomInbox.selectable = false;
			addChild(zoomInbox);
			
			zoomOutbox = new TextField();
			zoomOutbox.text ="-";
			zoomOutbox.x = zoomSlider.x - zoomSlider.width - 25;
			zoomOutbox.y = zoomInbox.y;
			zoomOutbox.height = 75;
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