indexing
	description	: "Enhancement of the toolbar. This toolbar appears flat %
				  %and use imagelist to store bitmaps - when available   "
	note		: "The common controls dll (WEL_COMMON_CONTROLS_DLL)     %
				  %needs to be loaded to use this control.               "
	author		: "Arnaud PICHERY [ aranud@mail.dotcom.fr ]"
	date		: "$Date$"
	revision	: "$Revision$"

class
	WEL_FLAT_TOOL_BAR

inherit
	WEL_TOOL_BAR
		redefine
			make,
			default_style,
			set_bitmap_size,
			set_button_size,
			add_bitmaps	
		end

	WEL_ILC_CONSTANTS
		export
			{NONE} all
		end

	WEL_WINDOWS_VERSION

creation
	make

feature {NONE} -- Initialization

	make (a_parent: WEL_WINDOW; an_id: INTEGER) is
			-- Create a toolbar with `a_parent' as parent and
			-- `an_id' as id.
		do
			{WEL_TOOL_BAR} Precursor(a_parent, an_id)
			bitmaps_width := 16 -- Default value
			bitmaps_height := 15 -- Default value
			if use_image_list_supported then
				use_image_list := True -- Default state
			end
		end

feature -- Access

	bitmaps_width: INTEGER
			-- 16 by default
	
	bitmaps_height: INTEGER
			-- 15 by default

	button_width: INTEGER
			-- 24 by default
	
	button_height: INTEGER
			-- 22 by default

	use_image_list: BOOLEAN
			-- Are we using ImageList for the toolbar?

	use_disabled_image_list: BOOLEAN is
			-- Are we using disabled ImageList for the toolbar?
		do
			Result := (disabled_image_list /= Void)
		end

	use_hot_image_list: BOOLEAN is
			-- Are we using hot ImageList for the toolbar?
		do
			Result := (hot_image_list /= Void)
		end

	last_disabled_bitmap_index: INTEGER

	last_hot_bitmap_index: INTEGER

	default_image_list: WEL_IMAGE_LIST
			-- ImageList associated with the toolbar
			-- Note: only used in the "Win95+IE3" version

	disabled_image_list: WEL_IMAGE_LIST
			-- ImageList associated with the toolbar for disabled
			-- buttons
			-- Note: only used in the "Win95+IE3" version

	hot_image_list: WEL_IMAGE_LIST
			-- ImageList associated with the toolbar for hot buttons
			-- Note: only used in the "Win95+IE3" version

feature -- Status report

	use_image_list_supported: BOOLEAN is
			-- Are ImageList in toolbars supported in the current
			-- version of Windows?
		once
			Result := comctl32_version >= version_470
		end

feature -- Status setting

	enable_use_image_list is
			-- Set the toolbar to use image lists.
			-- Note: Require Win95+IE3 or above
		require
			no_bitmap_present: not has_bitmap
			feature_supported: use_image_list_supported
		do
			use_image_list := True
		ensure
			image_list_in_use: use_image_list
		end

	disable_use_image_list is
			-- Set the toolbar not to use image lists.
			-- Note: This is the Default.
		require
			no_bitmap_present: not has_bitmap
		do
			use_image_list := False
		ensure
			image_list_not_used: not use_image_list
		end

feature -- Element change

	add_icon (a_icon: WEL_ICON) is
			-- Add an icon to the list of currently used images.
			--
			-- Note: The function will work with Comctrl32.dll version less
			-- than 4.70 but will not display the icon correctly: the background
			-- of the icons will always be set in black.
			-- With Comctrl32.dll >= 4.70 everything will run smoothly.
			-- Note2: Comctrl32.dll version 4.70 <=> Win95 + IE3
		require
			exists: exists
			icon_not_void: a_icon /= Void
		local
			a_bitmap: WEL_BITMAP
			a_toolbar_bitmap: WEL_TOOL_BAR_BITMAP
		do
			has_bitmap := True

			if use_image_list then
					-- Create the ImageList if not already created
				setup_image_list(False)

					-- Insert the bitmap into the image list.
				default_image_list.add_icon(a_icon)

				last_bitmap_index := default_image_list.last_position
			else
					-- We retrieve the bitmap from the icon.
				a_bitmap := a_icon.get_icon_info.color_bitmap
				create a_toolbar_bitmap.make_from_bitmap(a_bitmap)
				last_bitmap_index := cwin_send_message_result (item, Tb_addbitmap, 1, a_toolbar_bitmap.to_integer)
			end
		end

	add_disabled_icon(an_icon: WEL_ICON) is
			-- Add an icon to the disabled image list.
			--
			-- The feature is only supported under Windows95+IE3
			-- If such a configuration is not available, the function will
			-- do nothing.
		require
			icon_not_void: an_icon /= Void
		do
			if use_image_list then
					-- Create the ImageLists if not already created
				setup_disabled_image_list(False)

					-- Insert the bitmap into the image lists.
				disabled_image_list.add_icon(an_icon)
					
					-- Update the position
				last_disabled_bitmap_index := disabled_image_list.last_position
			else
				-- Not supported... do nothing.
			end
		end

	add_hot_icon(an_icon: WEL_ICON) is
			-- Add an icon to the hot image list.
			--
			-- The feature is only supported under Windows95+IE3
			-- If such a configuration is not available, the function will
			-- do nothing.
		require
			icon_not_void: an_icon /= Void
		do
			if use_image_list then
					-- Create the ImageLists if not already created
				setup_hot_image_list(False)

					-- Insert the bitmap into the image lists.
				hot_image_list.add_icon(an_icon)
					
					-- Update the position
				last_hot_bitmap_index := hot_image_list.last_position
			else
				-- Not supported... do nothing.
			end
		end

	add_bitmap (a_bitmap: WEL_BITMAP) is
			-- Add a bitmap to the list of currently used images.
		require
			exists: exists
			bitmap_not_void: a_bitmap /= Void
		local
			a_toolbar_bitmap: WEL_TOOL_BAR_BITMAP
		do
			has_bitmap := True

			if use_image_list then
					-- Create the ImageList if not already created
				setup_image_list(False)

					-- Insert the bitmap into the image list.
				default_image_list.add_bitmap(a_bitmap)

				last_bitmap_index := default_image_list.last_position
			else
					-- We build a "toolbar bitmap".
				create a_toolbar_bitmap.make_from_bitmap(a_bitmap)
				last_bitmap_index := cwin_send_message_result (item, Tb_addbitmap, 1, a_toolbar_bitmap.to_integer)
			end
		end

	add_disabled_bitmap(a_bitmap: WEL_BITMAP) is
			-- Add a bitmap to the disabled image list.
			--
			-- The feature is only supported under Windows95+IE3
			-- If such a configuration is not available, the function will
			-- do nothing.
		require
			bitmap_not_void: a_bitmap /= Void
		do
			if use_image_list then
					-- Create the ImageLists if not already created
				setup_disabled_image_list(False)

					-- Insert the bitmap into the image lists.
				disabled_image_list.add_bitmap(a_bitmap)
					
					-- Update the position
				last_disabled_bitmap_index := disabled_image_list.last_position
			else
				-- Not supported... do nothing.
			end
		end

	add_hot_bitmap(a_bitmap: WEL_BITMAP) is
			-- Add a bitmap to the hot image list.
			--
			-- The feature is only supported under Windows95+IE3
			-- If such a configuration is not available, the function will
			-- do nothing.
		require
			bitmap_not_void: a_bitmap /= Void
		do
			if use_image_list then
					-- Create the ImageLists if not already created
				setup_hot_image_list(False)

					-- Insert the bitmap into the image lists.
				hot_image_list.add_bitmap(a_bitmap)
					
					-- Update the position
				last_hot_bitmap_index := hot_image_list.last_position
			else
				-- Not supported... do nothing.
			end
		end

	add_masked_bitmap (a_bitmap: WEL_BITMAP; a_mask_bitmap: WEL_BITMAP) is
			-- Add a masked bitmap to the list of currently used images.
		require
			exists: exists
			bitmap_not_void: a_bitmap /= Void
			mask_not_void: a_mask_bitmap /= Void
			compatible_width_for_bitmaps: a_bitmap.width = a_mask_bitmap.width
			compatible_height_for_bitmaps: a_bitmap.height = a_mask_bitmap.height
			--| FIXME ARNAUD: Ensure that the mask is a monochrome bitmap
		local
			a_toolbar_bitmap: WEL_TOOL_BAR_BITMAP
		do
			has_bitmap := True

			if use_image_list then
					-- Create the ImageList if not already created
				setup_image_list(False)

					-- Insert the bitmap into the image list.
				default_image_list.add_masked_bitmap(a_bitmap, a_mask_bitmap)

				last_bitmap_index := default_image_list.last_position
			else
					-- We build a "toolbar bitmap".
				create a_toolbar_bitmap.make_from_bitmap(a_bitmap)
				last_bitmap_index := cwin_send_message_result (item, Tb_addbitmap, 1, a_toolbar_bitmap.to_integer)
			end
		end

	add_disabled_masked_bitmap (a_bitmap: WEL_BITMAP; a_mask_bitmap: WEL_BITMAP) is
			-- Add a masked bitmap to the disabled image list.
		require
			exists: exists
			bitmap_not_void: a_bitmap /= Void
			mask_not_void: a_mask_bitmap /= Void
			compatible_width_for_bitmaps: a_bitmap.width = a_mask_bitmap.width
			compatible_height_for_bitmaps: a_bitmap.height = a_mask_bitmap.height
			--| FIXME ARNAUD: Ensure that the mask is a monochrome bitmap
		local
			a_toolbar_bitmap: WEL_TOOL_BAR_BITMAP
		do
			if use_image_list then
					-- Create the ImageList if not already created
				setup_disabled_image_list(False)

					-- Insert the bitmap into the image list.
				disabled_image_list.add_masked_bitmap(a_bitmap, a_mask_bitmap)

				last_disabled_bitmap_index := disabled_image_list.last_position
			else
				-- Not supported... do nothing.
			end
		end

	add_hot_masked_bitmap (a_bitmap: WEL_BITMAP; a_mask_bitmap: WEL_BITMAP) is
			-- Add a masked bitmap to the hot image list.
		require
			exists: exists
			bitmap_not_void: a_bitmap /= Void
			mask_not_void: a_mask_bitmap /= Void
			compatible_width_for_bitmaps: a_bitmap.width = a_mask_bitmap.width
			compatible_height_for_bitmaps: a_bitmap.height = a_mask_bitmap.height
			--| FIXME ARNAUD: Ensure that the mask is a monochrome bitmap
		local
			a_toolbar_bitmap: WEL_TOOL_BAR_BITMAP
		do
			if use_image_list then
					-- Create the ImageList if not already created
				setup_hot_image_list(False)

					-- Insert the bitmap into the image list.
				hot_image_list.add_masked_bitmap(a_bitmap, a_mask_bitmap)

				last_hot_bitmap_index := hot_image_list.last_position
			else
				-- Not supported... do nothing.
			end
		end

feature -- Resizing

	set_bitmap_size (a_width, a_height: INTEGER) is
			-- Sets the size of the bitmapped images to be added to
			-- the toolbar.
			-- The size can be set only before adding any
			-- bitmaps to the toolbar otherwise all added bitmap
			-- are erased.
			--
			-- If an application does not explicitly set the bitmap
			-- size, the default size is 16 by 15 pixels.
		do
			bitmaps_width := a_width
			bitmaps_height := a_height

			if use_image_list then
					-- ImageList version
				setup_image_list(True)
				setup_hot_image_list(True)
				setup_disabled_image_list(True)
			else
					-- Plain Win95 version
				cwin_send_message (item, Tb_setbitmapsize, 0, cwin_make_long (a_width, a_height))
			end
		end

	set_button_size (a_width, a_height: INTEGER) is
			-- Set the size of the buttons to be added to the
			-- toolbar.
			-- The size can be set only before adding any buttons
			-- to the toolbar. If an application does not
			-- explicitly set the button size, the size defaults
			-- to 24 by 22 pixels.
		do
			cwin_send_message (item, Tb_setbuttonsize, 0,
				cwin_make_long (a_width, a_height))
			button_width := a_width
			button_height := a_height
		end

feature -- Obsolete

	add_bitmaps (tb_bitmap: WEL_TOOL_BAR_BITMAP; bitmap_count: INTEGER) is
			-- Add bitmaps.
		obsolete
			"use add_bitmap instead"
		local
			a_bitmap: WEL_BITMAP
		do
			has_bitmap := True

			if use_image_list then
					-- ImageList version
				check
					-- This is not compatible with ImageLists
					no_predefined_bitmap: not tb_bitmap.predefined_id
					no_disabled_bitmaps: not use_disabled_image_list
					no_hot_bitmaps: not use_hot_image_list
				end

					-- Create the ImageList if not already created
				setup_image_list(False)

					-- Insert the bitmap into the image list.
				if tb_bitmap.internal_bitmap /= Void then
					default_image_list.add_bitmap(tb_bitmap.internal_bitmap)
				else
					create a_bitmap.make_by_id(tb_bitmap.internal_bitmap_id)
					default_image_list.add_bitmap(a_bitmap)
				end

				last_bitmap_index := default_image_list.last_position
			else
					-- Plain Win95 version
				last_bitmap_index := cwin_send_message_result (item, Tb_addbitmap, bitmap_count, tb_bitmap.to_integer)
			end
		end

feature {NONE} -- Implementation

	setup_image_list(overwrite: BOOLEAN) is
			-- if `overwrite' is set, create the image list only if it existed.
			-- if `overwrite' is not set, create the image list only if it did not exist.
		do
			if (overwrite and default_image_list /= Void) or ((not overwrite) and default_image_list = Void) then
				create default_image_list.make(bitmaps_width, bitmaps_height, Ilc_colorddb, True)
				cwin_send_message (item, Tb_setimagelist, 0, cwel_pointer_to_integer (default_image_list.item))
			end
		end

	setup_disabled_image_list(overwrite: BOOLEAN) is
			-- if `overwrite' is set, create the image list only if it existed.
			-- if `overwrite' is not set, create the image list only if it did not exist.
		do
			if (overwrite and disabled_image_list /= Void) or ((not overwrite) and disabled_image_list = Void) then
				create disabled_image_list.make(bitmaps_width, bitmaps_height, Ilc_colorddb, True)
				cwin_send_message (item, Tb_setdisabledimagelist, 0, cwel_pointer_to_integer (disabled_image_list.item))
			end
		end

	setup_hot_image_list(overwrite: BOOLEAN) is
			-- if `overwrite' is set, create the image list only if it existed.
			-- if `overwrite' is not set, create the image list only if it did not exist.
		do
			if (overwrite and hot_image_list /= Void) or ((not overwrite) and hot_image_list = Void) then
				create hot_image_list.make(bitmaps_width, bitmaps_height, Ilc_colorddb, True)
				cwin_send_message (item, Tb_sethotimagelist, 0, cwel_pointer_to_integer (hot_image_list.item))
			end
		end

	default_style: INTEGER is
			-- Default style used to create the control
		once
			Result := Ws_visible + Ws_child + Tbstyle_tooltips
	
				-- Add the flat style if available.
			if comctl32_version >= version_470 then
				Result := Result + Tbstyle_flat
			end
		end

invariant
	image_list_used_when_available: use_image_list implies use_image_list_supported
	disabled_image_list_only_when_bitmap: use_disabled_image_list implies has_bitmap
	hot_image_list_only_when_bitmap: use_hot_image_list implies has_bitmap

end -- class WEL_FLAT_TOOL_BAR
