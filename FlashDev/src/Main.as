package
{
	import flash.display.Bitmap;
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
	import Timeline.Timeline;
	import Timeline.TimelineItem;
	
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
		
		// Constant that defines an array of images to load in sequence.
		public static const IMAGES:Array = [POLITICAL_ICON, UNION_ICON, CONFEDERATE_ICON, 
											BATTLE_ICON, ART_ICON, TITLE, ARROWS,
											POLITICALFRONT, BATTLES, LIFEOFBEARD, CIVILWARART];
		
		//} endregion
		
		public var timelineItemList:Vector.<TimelineItem>;		//stores all the events from our database in sorted order
		public var currentItemList:Vector.<TimelineItem>;		//stores the currently shown events
		private var currentItems:MovieClip;
		public var iconArray:Vector.<Bitmap>;						//stores all the icons
		//private var icons:Object;             //associative array of all icons. the key is given by the asset constants.
		private var loaded:int = 0;           //keeps track of which images needs to be loaded next.
		
		//{ region UI Elements
		
		private var title:MovieClip;
		private var political:MovieClip;
		private var battles:MovieClip;
		private var artist:MovieClip;
		private var art:MovieClip;
		private var arrows:MovieClip;
		
		private var zoomInbox:TextField;
		private var zoomOutbox:TextField;
		
		private var timeline:Timeline;
		
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
			
			//TODO throw up a loading graphic
			
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
			}
			//otherwise, load the xml file.
			else
			{
				trace("loading XML now...");
				var xmlloader:URLLoader = new URLLoader();
				xmlloader.addEventListener(Event.COMPLETE, parseXML);
				xmlloader.load(new URLRequest(XMLDATA));
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
					tEvent.month = xml.ss::Worksheet..ss::Table.children()[i].children()[1].children()[0];
					tEvent.day = xml.ss::Worksheet..ss::Table.children()[i].children()[2].children()[0];
					tEvent.type = xml.ss::Worksheet..ss::Table.children()[i].children()[3].children()[0];
					tEvent.shortDes = xml.ss::Worksheet..ss::Table.children()[i].children()[4].children()[0];
					tEvent.fullDes = xml.ss::Worksheet..ss::Table.children()[i].children()[5].children()[0];
					if(tEvent.type == "Battle")
					{
						tEvent.victor = xml.ss::Worksheet..ss::Table.children()[i].children()[6].children()[0];	
						tEvent.importance = xml.ss::Worksheet..ss::Table.children()[i].children()[7].children()[0];						
					}
					
					timelineItemList.push(tEvent);					
				}
			}
			
			trace("xml done reading");
			populateUI();
		}
		
		public function zoomIn(e:Event = null):void
		{
			/*
			timeline.view.width *= .9;
			timeline.changeView(timeline.view);
			/*/
			timeline.zoomMomentum = -.1;
			//*/
		}
		
		public function zoomOut(e:Event = null):void
		{
			/*
			timeline.view.width /= .9;
			timeline.changeView(timeline.view);
			/*/
			timeline.zoomMomentum = .1;
			//*/
		}
		
		public function changeZoomLevel(beginDateZoom:int, endDateZoom:int):void
		{			
			var newBegin:int = beginDate + beginDateZoom;
			var newEnd:int = endDate + endDateZoom;
			
			if(newBegin < MINDATE)
			{
				newBegin = MINDATE;
			}
			else if(newEnd > MAXDATE)
			{
				newEnd = MAXDATE;
			}
						
			if(newBegin > newEnd)
			{
				trace("Date Error in timeline.changeZoomLevel");
			}
			else
			{
				beginDate = newBegin;
				endDate = newEnd;
				emptyTimeline();
				populateUI();
			}
		}
		
		private function populateUI():void
		{		
			timeline = new Timeline(100, 50, 550, 455, timelineItemList, iconArray);
			addChild(timeline);
			
			trace("populateUI");
			
			title = new MovieClip();
			title.addChild(new Bitmap((iconArray[5]).bitmapData.clone()));
			title.x = 200;
			title.y = 15;
			this.addChild(title);
			/*
			arrows = new MovieClip();
			arrows.addChild(new Bitmap((iconArray[6]).bitmapData.clone()));
			arrows.x = lineStart;
			arrows.y = lineHeight;
			this.addChild(arrows);
			*/
			political = new MovieClip();
			political.addChild(new Bitmap((iconArray[7]).bitmapData.clone()));
			political.x = 15;
			political.y = ((lineHeight - 100) / 4) * 1;
			this.addChild(political);
			
			battles = new MovieClip();
			battles.addChild(new Bitmap((iconArray[8]).bitmapData.clone()));
			battles.x = 15;
			battles.y = ((lineHeight - 100) / 4) * 2;
			this.addChild(battles);
			
			artist = new MovieClip();
			artist.addChild(new Bitmap((iconArray[9]).bitmapData.clone()));
			artist.x = 15;
			artist.y = ((lineHeight - 100) / 4) * 3;
			this.addChild(artist);
			
			art = new MovieClip();
			art.addChild(new Bitmap((iconArray[10]).bitmapData.clone()));
			art.x = 15;
			art.y = ((lineHeight - 100) / 4) * 4;
			this.addChild(art);
			
			zoomInbox = new TextField();
			zoomInbox.text ="zoomIn";
			zoomInbox.x = lineEnd + 10;
			zoomInbox.y = lineHeight + 50;
			zoomInbox.addEventListener(MouseEvent.CLICK, zoomIn);
			this.addChild(zoomInbox);
			
			zoomOutbox = new TextField();
			zoomOutbox.text ="zoomOut";
			zoomOutbox.x = lineEnd + 10;
			zoomOutbox.y = lineHeight + 70;
			zoomOutbox.addEventListener(MouseEvent.CLICK, zoomOut);
			this.addChild(zoomOutbox);
		}
		
		private function emptyTimeline():void
		{
			trace("emtpyTimeline");
			//clear current events and objects on screen
			while (numChildren > 0) { removeChildAt(0); }
		}
		
	}
	
}