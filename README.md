The app screen is split into two views

Installation steps:

1. git clone 
2. clean pods
3. install pods
4. carthage install

-------------------------------------------------------------------

IMPORTANT NOTES:

1. You need a folder called "glaucomaApp" in the Box root folder

2. There are several features implemented in this project that all you need to is uncomment them ot call them (picture saving, picture loading, etc)

3. there are several bugs dealing with saturation. (these bugs were introduced when put all the effects on to one view) 

	a. bugs include resizing and moving the view, and custom views cant use the effect.
	
--------------------------


1. MainImageView
	
	Takes up the larger portion of the screen. Includes the actual poster background and all the views upon it.

	CustomObjects -> Custom placed objects on the screen.
	CustomView (Squares) -> CustomView the user can manipulate using the sideview
	GridLines -> 3 Gridlins that divide the app into 6 quadrants, can be toggled from the sideview.

	These are the views on the MainImageView.

2. SideView

	Includes a UIStackView with the sliders and the corresponding icons, and control buttons for reset/clear/export.
	Sliders manipulate the selected CustomView.

3. CustomView

	Important part of the app. CustomView is just a square that uses a pod library for the blur effect, and a grey background alpha change for the luminosity.
	When selected, it gives a red border. isSelected in the code determines this.
	There is an array called customViewUpdateList which stores all the CustomViews on the screen. This is iterated over to find which one is selected, and the effects are done on that.

4. Lifecycle

	A dialog pops up in the viewDidCreate method that pops uo the enter patient dialog. This name is stored on the bottom of the screen as a black bar (UIView on the MainImageView).
	User taps on the screen, CustomView is created. By default, the icons on the sideview are de selected and then change visuals when selected using the controlStack(isEnabled).
	Once created, the customView is added to the array. On each tap to a customview, the array is iterated over to become selected and makes it easier for manipulation and deletion.
	Data is stored in the object file.
	When deleting, the item is deleted from the array as well as the view.(2 step process)
	The export requires the app to have acces to photo gallery, needs to be given permission on first run. Suggested to test run and get this done so it is not brought up again.
	Export saves into the photo gallery.
