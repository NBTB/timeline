package 
{
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*
	
	public class timeline extends MovieClip
	{
		public var timelineLine:MovieClip;
		public var timelineEventList:Vector.<TimelineEvent>;		//stores all the events from our database in sorted order
		public var currentEventList:Vector.<TimelineEvent>;		//stores the currently shown events
		public var iconArray:Vector.<Bitmap>;						//stores all the icons
		
		private var beginDate:int;
		private var endDate:int;
		private var MINDATE:int = 1810;
		private var MAXDATE:int = 1895;
		private var lineStart:int = 100;
		private var lineEnd:int = 650;
		private var lineHeight:int = 500;
		
		//zoom tool
		
		public function timeline()
		{
			iconArray = new Vector.<Bitmap>();
			beginDate = 1860;
			endDate = 1865;
			var readMan:ReadManager = new ReadManager(this);
			trace("back in timeline");
		}
		
		public function zoomIn():void
		{
			changeZoomLevel(1,-1);
		}
		
		public function zoomOut():void
		{
			changeZoomLevel(-1,1);
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
				populateTimeline();
			}
		}
		
		private function populateTimeline():void
		{			
			//create Timeline Line
			createLine();
			
			//create Text stuff in Timeline
			createText();
			
			//load the Events into the timeline
			createEvents();
			
			var zoomTool:TextField;
			zoomTool = new TextField();
			zoomTool.text ="zoomTool";
			zoomTool.x = lineEnd + 10;
			zoomTool.y = lineHeight + 50;
			this.addChild(zoomTool);
		}
		
		private function emptyTimeline():void
		{
			//clear current events and objects on screen
			for(var i:int = 0; i < this.numChildren; i++)
			{
				this.removeChildAt(i);
			}
		}		
		
		private function createLine():void
		{	
			trace("creating line");
			//the line of the timeline
			var line:Shape;
			line = new Shape();
			line.graphics.lineStyle(1, 0x000000,1);
			line.graphics.beginFill(0x002772,0.5);
			line.graphics.drawRect(lineStart, lineHeight-4, lineEnd-lineStart, 8)
			line.graphics.endFill();
			this.addChild(line);
			
			//left arrow
			var ltri:Shape;
			ltri = new Shape();
			ltri.graphics.lineStyle(1, 0x000000,1);
			ltri.graphics.beginFill(0x555555,1);
			ltri.graphics.drawTriangles(Vector.<Number>([lineStart-20,lineHeight, lineStart,lineHeight+10, lineStart,lineHeight-10]),Vector.<int>([0,1,2]));
			ltri.graphics.endFill();
			this.addChild(ltri);
			
			//right arrow
			var rtri:Shape;
			rtri = new Shape();
			rtri.graphics.lineStyle(1, 0x000000,1);
			rtri.graphics.beginFill(0x555555,1);
			rtri.graphics.drawTriangles(Vector.<Number>([lineEnd+20,lineHeight, lineEnd,lineHeight+10, lineEnd,lineHeight-10]),Vector.<int>([0,1,2]));
			rtri.graphics.endFill();
			this.addChild(rtri);
						
			var bText:TextField;
			bText = new TextField();
			bText.text = beginDate.toString();
			bText.x = lineStart - 15;
			bText.y = lineHeight + 20;
			this.addChild(bText);
			
			var eText:TextField;
			eText = new TextField();
			eText.text = endDate.toString();
			eText.x = lineEnd-15;
			eText.y = lineHeight + 20;
			this.addChild(eText);
			
			var midDateAmount:int = endDate - beginDate;
			var skipAmount:int = 1;
			
			var scaler:int = midDateAmount;
			/*
			if(midDateAmount <= 5)
			{
				scaler = midDateAmount;
				skipAmount = 1;
			}
			else if(midDateAmount <= 15)
			{
				scaler = midDateAmount/2;
				skipAmount = 2;
			}
			else if(midDateAmount <= 30)
			{
				scaler = midDateAmount/4;
				skipAmount = 4;
			}
			*/
			while(scaler > 8)
			{
				scaler = scaler / 2;
				skipAmount += 2;
			}
			
			//var oddFix:int = 0;
			/*
			var advanceNum:int = midDateAmount / scaler;
			//check for odd numbers
			if(midDateAmount%2 != 0 && scaler != midDateAmount)
			{
				scaler++;
				//works for < 15 
				oddFix = (lineEnd - lineStart) / scaler / 2;
				
				//works for < 30
				//oddFix = (lineEnd - lineStart) / scaler;
			}
			*/
			
			trace("midDateAmount: " + midDateAmount);
			trace("scaler: " + scaler);
			var skipNum:int = 1;
			
			for(var i:int = 1; i < midDateAmount; i++)
			{
				if(skipNum >= skipAmount)
				{
					skipNum = 0;
					
					//solid lines on datebar/timeline
					var dLine:Shape = new Shape();
					dLine.graphics.moveTo(lineStart + ((lineEnd - lineStart)/ midDateAmount * i), lineHeight-15);
					dLine.graphics.lineStyle(2, 0x000000,1);
					dLine.graphics.lineTo(lineStart + ((lineEnd - lineStart)/ midDateAmount * i), lineHeight+15);
					this.addChild(dLine);
					
					//dates
					var dLineText:TextField = new TextField();
					dLineText.text = (beginDate+i).toString();
					dLineText.x = lineStart + ((lineEnd - lineStart)/ midDateAmount * i) - 15;
					dLineText.y = lineHeight + 40;
					this.addChild(dLineText);
					
					//faint lines
					var faintLine:Shape;
					faintLine = new Shape();
					faintLine.graphics.moveTo(lineStart + ((lineEnd - lineStart)/ midDateAmount * i), 50);
					faintLine.graphics.lineStyle(2, 0x111188, 0.1);
					faintLine.graphics.lineTo(lineStart + ((lineEnd - lineStart)/ midDateAmount * i), lineHeight-15);
					this.addChild(faintLine);
				}
				skipNum++;
			}
				/*
			for(var i = 1; i < scaler; i++)
			{
				/*
				//solid lines on datebar/timeline
				var dLine:Shape = new Shape();
				dLine.graphics.moveTo(lineStart + ((lineEnd - lineStart)/ midDateAmount * i), lineHeight-15);
				dLine.graphics.lineStyle(2, 0x000000,1);
				dLine.graphics.lineTo(lineStart + ((lineEnd - lineStart)/ midDateAmount * i), lineHeight+15);
				this.addChild(dLine);
				
				//dates
				var dLineText:TextField = new TextField();
				dLineText.text = (beginDate+i).toString();
				dLineText.x = lineStart + ((lineEnd - lineStart)/ midDateAmount * i) - 15;
				dLineText.y = lineHeight + 40;
				this.addChild(dLineText);
				
				//faint lines
				var faintLine:Shape;
				faintLine = new Shape();
				faintLine.graphics.moveTo(lineStart + ((lineEnd - lineStart)/ midDateAmount * i), 50);
				faintLine.graphics.lineStyle(2, 0x111188, 0.3);
				faintLine.graphics.lineTo(lineStart + ((lineEnd - lineStart)/ midDateAmount * i), lineHeight-15);
				this.addChild(faintLine);
				*/				
				/*
				//solid lines on datebar/timeline
				var dLine:Shape = new Shape();
				dLine.graphics.moveTo(lineStart + ((lineEnd - lineStart + oddFix)/ scaler * i), lineHeight-15);
				dLine.graphics.lineStyle(2, 0x000000,1);
				dLine.graphics.lineTo(lineStart + ((lineEnd - lineStart + oddFix)/ scaler * i), lineHeight+15);
				this.addChild(dLine);
				
				//dates
				var dLineText:TextField = new TextField();
				dLineText.text = (beginDate+(i* advanceNum)).toString();
				dLineText.x = lineStart + ((lineEnd - lineStart + oddFix)/ scaler * i) - 15;
				dLineText.y = lineHeight + 40;
				this.addChild(dLineText);
				
				//faint lines
				var faintLine:Shape;
				faintLine = new Shape();
				faintLine.graphics.moveTo(lineStart + ((lineEnd - lineStart + oddFix)/ scaler * i), 50);
				faintLine.graphics.lineStyle(2, 0x111188, 0.3);
				faintLine.graphics.lineTo(lineStart + ((lineEnd - lineStart + oddFix)/ scaler * i), lineHeight-15);
				this.addChild(faintLine);
			}
			*/
			/*
			var lineE3:Shape;
			lineE3 = new Shape();
			lineE3.graphics.moveTo(lineStart + ((lineEnd - lineStart)/ 3 * 1), lineHeight-15);
			lineE3.graphics.lineStyle(2, 0x000000,1);
			lineE3.graphics.lineTo(lineStart + ((lineEnd - lineStart)/ 3 * 1), lineHeight+15);
			this.addChild(lineE3);
			
			var lineE4:Shape;
			lineE4 = new Shape();
			lineE4.graphics.moveTo(lineStart + ((lineEnd - lineStart)/ 3 * 2), lineHeight-15);
			lineE4.graphics.lineStyle(2, 0x000000,1);
			lineE4.graphics.lineTo(lineStart + ((lineEnd - lineStart)/ 3 * 2), lineHeight+15);
			this.addChild(lineE4);
			
			var lineE4Text:TextField;
			lineE4Text = new TextField();
			lineE4Text.text ="1864";
			lineE4Text.x = lineStart + ((lineEnd - lineStart)/ 3 * 2) - 15;
			lineE4Text.y = lineHeight + 20;
			this.addChild(lineE4Text);
			
			var lineE42:Shape;
			lineE42 = new Shape();
			lineE42.graphics.moveTo(lineStart + ((lineEnd - lineStart)/ 3 * 2), 50);
			lineE42.graphics.lineStyle(2, 0x111188,0.3);
			lineE42.graphics.lineTo(lineStart + ((lineEnd - lineStart)/ 3 * 2), lineHeight-15);
			this.addChild(lineE42);
			*/
		}
		
		private function createText():void
		{			
			trace("creating Text");
			var format1:TextFormat = new TextFormat();
			format1.size = 25;
			 
			var format2:TextFormat = new TextFormat();
			format2.italic = true;
			
			var nbtbT:TextField;
			nbtbT = new TextField();
			nbtbT.width = 700;
			nbtbT.text = "The Night Before the Battle and the American Civil War";
			nbtbT.setTextFormat(format1);
			nbtbT.setTextFormat(format2, 0,27);
			nbtbT.x = 100;
			nbtbT.y = 15;
			this.addChild(nbtbT);
			
			format1.size = 15;
			
			var politicalT:TextField;
			politicalT = new TextField();
			politicalT.text ="Political Front";
			politicalT.setTextFormat(format1);
			politicalT.width = 90;
			politicalT.height = 20;
			politicalT.border = true;
			politicalT.background = true;
			politicalT.backgroundColor = 0xFFFFFF;
			politicalT.wordWrap = true;
			politicalT.x = 15;
			politicalT.y = ((lineHeight - 100) / 4) * 1;
			this.addChild(politicalT);
			
			var battleT:TextField;
			battleT = new TextField();
			battleT.text ="Battles of the Civil War";
			battleT.setTextFormat(format1);
			battleT.width = 90;
			battleT.height = 40;
			battleT.border = true;
			battleT.background = true;
			battleT.backgroundColor = 0x788C42;
			battleT.wordWrap = true;
			battleT.x = 15;
			battleT.y = ((lineHeight - 100) / 4) * 2;
			this.addChild(battleT);
			
			var artistT:TextField;
			artistT = new TextField();
			artistT.text ="Life of James Henry Beard";
			artistT.setTextFormat(format1);
			artistT.width = 90;
			artistT.height = 40;
			artistT.border = true;
			artistT.background = true;
			artistT.backgroundColor = 0x935E3E;
			artistT.wordWrap = true;
			artistT.x = 15;
			artistT.y = ((lineHeight - 100) / 4) * 3;
			this.addChild(artistT);
			
			var artT:TextField;
			artT = new TextField();
			artT.text ="Art of the Civil War Era";
			artT.setTextFormat(format1);
			artT.width = 90;
			artT.height = 40;
			artT.border = true;
			artT.background = true;
			artT.backgroundColor = 0xFFBF01;
			artT.wordWrap = true;
			artT.x = 15;
			artT.y = ((lineHeight - 100) / 4) * 4;
			this.addChild(artT);
		}
		
		private function createEvents():void
		{
			trace("creating Events");
			currentEventList = new Vector.<TimelineEvent>();
			var lastBattle:int = 0;
			var lastPolitical:int = 0;
			var safeZone:int = 50;
			var by1:int = 220;
			var by2:int = 250;
			var by3:int = 280;
			var byPos:int = by1;
			var py1:int = 100;
			var py2:int = 130;
			var py3:int = 170;
			var pyPos:int = py1;
			
			for(var i:int=0; i<timelineEventList.length; i++)
			{
				if(timelineEventList[i].year >= beginDate && timelineEventList[i].year < endDate)
				{
					currentEventList.push(timelineEventList[i]);
					
					var midDateAmount:int = endDate - beginDate;
					
					var yDate:int = ((lineEnd - lineStart)/ midDateAmount) * (timelineEventList[i].year - beginDate);
					var mDate:int = (((lineEnd - lineStart)/ midDateAmount) / 12) * timelineEventList[i].month;
					var dDate:int = ((((lineEnd - lineStart)/ midDateAmount) / 12) / 31) * timelineEventList[i].day;
					
					var xPos:int = lineStart + yDate + mDate + dDate;
					trace("Date: " + timelineEventList[i].month + " " + timelineEventList[i].day + ", " + timelineEventList[i].year);
					trace(yDate + " " + mDate + " " + dDate);
					var circle:Shape;
					circle = new Shape();
					circle.graphics.lineStyle(2, 0x777777, 1);
					var bit:Bitmap;
					
					if(timelineEventList[i].type == "Battle")
					{
						if(timelineEventList[i].victor == "Union")
						{
							circle.graphics.beginFill(0x002772,0.5);
							bit = new Bitmap((iconArray[1]).bitmapData.clone());
						}
						else if(timelineEventList[i].victor == "Confederate")
						{
							circle.graphics.beginFill(0x777777,0.5);
							bit = new Bitmap((iconArray[2]).bitmapData.clone());
						}
						else
						{
							circle.graphics.beginFill(0x722700,0.5);	
							bit = new Bitmap((iconArray[3]).bitmapData.clone());						
						}
						
						if(xPos - lastBattle < safeZone)
						{
							if(byPos == by1) byPos = by2;
							else if(byPos == by2) byPos = by3;
							else byPos = by1;
						}
						else
						{
							byPos = by1;
						}
						circle.x = xPos;
						circle.y = byPos;
						circle.graphics.drawCircle(0,0,10);
						lastBattle = xPos;
						
						bit.scaleX = 0.1;
						bit.scaleY = 0.1;
						bit.x = circle.x - bit.width/2;
						bit.y = circle.y - bit.height/2;
						this.addChild(bit);
					}
					else
					{
						
						circle.graphics.beginFill(0xFFCC11,0.5);
						
						if(xPos - lastPolitical < safeZone)
						{
							if(pyPos == py1) pyPos = py2;
							else if(pyPos == py2) pyPos = py3;
							else pyPos = py1;
						}
						else
						{
							pyPos = py1;
						}
						circle.x = xPos;
						circle.y = pyPos;
						circle.graphics.drawCircle(0,0,10);
						lastPolitical = xPos;
						
						bit = new Bitmap((iconArray[0]).bitmapData.clone());
						bit.scaleX = 0.1;
						bit.scaleY = 0.1;
						bit.x = circle.x - bit.width/2;
						bit.y = circle.y - bit.height/3*2;
						this.addChild(bit);
					}
					circle.graphics.endFill();
					this.addChild(circle);
				}
			}
			/*
			var circle:Shape;
			circle = new Shape();
			circle.graphics.lineStyle(7, 0x777777,1);
			circle.graphics.beginFill(0xAAAAAA,0.5);
			circle.graphics.drawCircle(250,100,50);
			circle.graphics.endFill();
			this.addChild(circle);
					
			var Ucircle:Shape;
			Ucircle = new Shape();
			Ucircle.graphics.lineStyle(7, 0x002772,1);
			Ucircle.graphics.beginFill(0x002772,0.5);
			Ucircle.graphics.drawCircle(470,100,30);
			Ucircle.graphics.endFill();
			this.addChild(Ucircle);
			*/
		}
  	}	
}