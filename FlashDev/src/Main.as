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
	import flash.events.TextEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import Timeline.Timeline;
	import Timeline.TimelineItem;
	import Timeline.Slider;
	
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
		public static const POLITICAL_ICON:String = "data/political.png";
		public static const UNION_ICON:String = "data/union.png";
		public static const CONFEDERATE_ICON:String = "data/confederate.png";
		public static const BATTLE_ICON:String = "data/battle.png";
		public static const ART_ICON:String = "data/art.png";
		public static const TITLE:String = "data/title.png";
		public static const ARROWS:String = "data/arrows.png";
		public static const POLITICALFRONT:String = "data/PoliticalFront.png";	
		public static const BATTLES:String = "data/Battles.png";
		public static const LIFEOFBEARD:String = "data/LifeOfBeard.png";
		public static const CIVILWARART:String = "data/CivilWarArt.png";
		public static const BACKGROUND:String = "data/Background.png";
		
		// Constant that defines an array of images to load in sequence.
		public static const IMAGES:Array = [POLITICAL_ICON, UNION_ICON, CONFEDERATE_ICON, 
											BATTLE_ICON, ART_ICON, TITLE, ARROWS,
											POLITICALFRONT, BATTLES, LIFEOFBEARD, CIVILWARART, BACKGROUND];
		
		//} endregion
		
		public var timelineItemList:Vector.<TimelineItem>;		//stores all the events from our database in sorted order
		public var currentItemList:Vector.<TimelineItem>;		//stores the currently shown events
		private var currentItems:MovieClip;
		public var iconArray:Vector.<Bitmap>;						//stores all the icons
		private var loaded:int = 0;           //keeps track of which images needs to be loaded next.
		
		//{ region UI Elements
		
		private var loadingThingy:DisplayObject;
		
		private var title:MovieClip;
		private var background:MovieClip;
		private var political:FilterButton;
		private var battles:FilterButton;
		private var artist:FilterButton;
		private var art:FilterButton;
		private var arrows:MovieClip;
		
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
			
			//TODO a better loading graphic
			loadingThingy = new TextField();
			TextField(loadingThingy).text = "Loading... 0/" + (IMAGES.length + 1);
			loadingThingy.x = 250;
			loadingThingy.y = 250;
			addChild(loadingThingy);
			
			iconArray = new Vector.<Bitmap>();
			beginDate = 1860;
			endDate = 1866;
			
			loadNext();
		}
		
		public function loadNext(e:Event = null):void {
			//The first time this is called, e is null, every other time, e.target is a Loader that just finished.
			if(e != null) { iconArray.push(e.target.loader.content); }
			
			
			//if there are still images to load, load the next one.
			if (loaded < IMAGES.length)
			{
				trace("loading image #" + loaded + " now...");
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadNext);
				loader.load(new URLRequest(IMAGES[loaded]));
				loaded++;
				
				//TODO update loading graphic
				TextField(loadingThingy).text = "Loading... " + loaded + "/" + (IMAGES.length + 1);
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
				TextField(loadingThingy).text = "Loading data... " + loaded + "/" + (IMAGES.length + 1);
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
			timelineItemList.sort(TimelineItem.sortItems);
			
			trace("xml done reading");
			populateUI();
		}
		private function populateUI():void
		{		
			timeline = new Timeline(20, 525, 1225, 250, timelineItemList, iconArray);
			addChild(timeline);
			
			trace("populateUI");
			
			title = new MovieClip();
			title.addChild(new Bitmap((iconArray[5]).bitmapData.clone()));
			title.x = 15;
			title.y = 15;
			this.addChild(title);
			
			background = new MovieClip();
			background.addChild(new Bitmap((iconArray[11]).bitmapData.clone()));
			background.x = 0;
			background.y = 0;
			background.width = 1270;
			background.height = 900;
			this.addChild(background);
			this.setChildIndex(background, 0);
			/*
			arrows = new MovieClip();
			arrows.addChild(new Bitmap((iconArray[6]).bitmapData.clone()));
			arrows.x = lineStart;
			arrows.y = lineHeight;
			this.addChild(arrows);
			*/
			political = new FilterButton("Political",new Bitmap((iconArray[7]).bitmapData.clone()));
			political.x = 15;
			political.y = ((lineHeight - 100) / 4) * 1;
			political.addEventListener(MouseEvent.CLICK, setFilter);
			this.addChild(political);
			
			battles = new FilterButton("Battle", new Bitmap((iconArray[8]).bitmapData.clone()));
			battles.x = 15;
			battles.y = ((lineHeight - 100) / 4) * 2;
			battles.addEventListener(MouseEvent.CLICK, setFilter);
			this.addChild(battles);
			
			artist = new FilterButton("Artist", new Bitmap((iconArray[9]).bitmapData.clone()));
			artist.x = 15;
			artist.y = ((lineHeight - 100) / 4) * 3;
			artist.addEventListener(MouseEvent.CLICK, setFilter);
			this.addChild(artist);
			
			art = new FilterButton("Art", new Bitmap((iconArray[10]).bitmapData.clone()));
			art.x = 15;
			art.y = ((lineHeight - 100) / 4) * 4;
			art.addEventListener(MouseEvent.CLICK, setFilter);
			this.addChild(art);
			
			var tempFormat = new TextFormat();
			tempFormat.color = 0xF5F5F5;
			tempFormat.size = 48;
			
			var zoomSlider:Slider = new Slider(7);
			zoomSlider.x = 200;
			zoomSlider.y = 500;
			//Flip the Slider because in Timeline.as, a higher targetZoom means we're zooming out
			//Great job, whoever coded it like that. Sound logic.
			zoomSlider.rotation = 180;
			addChild(zoomSlider);
			addEventListener(MouseEvent.MOUSE_UP, zoomSlider.SliderUp);
			zoomInbox = new TextField();
			zoomInbox.text ="+";
			zoomInbox.x = 205;
			zoomInbox.y = zoomSlider.y - (zoomSlider.height / 2);
			zoomInbox.height = 75;
			zoomInbox.width = 40;
			//zoomInbox.addEventListener(MouseEvent.CLICK, timeline.zoomIn);
			zoomInbox.setTextFormat(tempFormat);
			zoomInbox.selectable = false;
			addChild(zoomInbox);
			
			zoomOutbox = new TextField();
			zoomOutbox.text ="-";
			zoomOutbox.x = 15;
			zoomOutbox.y = zoomSlider.y - (zoomSlider.height / 2);
			zoomOutbox.height = 75;
			zoomOutbox.width = 20;
			//zoomOutbox.addEventListener(MouseEvent.CLICK, timeline.zoomOut);
			zoomOutbox.setTextFormat(tempFormat);
			zoomOutbox.selectable = false;
			addChild(zoomOutbox);
			
			setFilter();
			//Show info box for the first timeline item when the program starts
			timeline.Field.items[0].dispatchEvent(new MouseEvent(MouseEvent.CLICK, true, false));
			removeChild(loadingThingy);
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