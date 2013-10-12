//
//  TMProtocol.h
//  TileMenu
//
//  Created by Andrey K on 20.19.12.
//  Copyright (c) Abby's LLC 2012. All rights reserved.
//

#ifndef MGTileMenu_MGTileMenuDelegate_h
#define MGTileMenu_MGTileMenuDelegate_h
#endif

#define MG_PAGE_SWITCHING_TILE_INDEX -1

@class NmaTileMenuController;
@protocol NmaTMProtocol <NSObject>

@optional
- (BOOL) isTileSelected:(NSInteger)tileNumber;

// Tile backgrounds.
@optional
- (CGGradientRef)gradientForTile:(NSInteger)tileNumber inMenu:(NmaTileMenuController *)tileMenu; // zero-based tileNumber
- (UIColor *)colorForTile:(NSInteger)tileNumber inMenu:(NmaTileMenuController *)tileMenu; // zero-based tileNumber
// N.B. Background images take precedence over gradients, which take precedence over flat colors. Only one will be rendered.
//      Background images are scaled (non-proportionately, so it's best to supply square images) to fit the tile.
//      If none of the above three methods are implemented, or don't return valid data, tiles be rendered with the menu's tileGradient.
//      In all cases, the tiles' backgrounds will be clipped to a rounded rectangle.
//      Note that these methods are also called for the page-switching tile, with tileNumber MG_PAGE_SWITCHING_TILE_INDEX.

// Interaction/notification
@required
- (void)tileMenu:(NmaTileMenuController *)tileMenu didActivateTile:(NSInteger)tileNumber; // zero-based tileNumber
// N.B. The above method fires when the user has pressed and released a given tile, thus choosing or activating it.

@optional
- (void)tileMenuWillDisplay:(NmaTileMenuController *)tileMenu;
- (void)tileMenuDidDisplay:(NmaTileMenuController *)tileMenu;

- (BOOL)tileMenuShouldDismiss:(NmaTileMenuController *)tileMenu;
- (void)tileMenuWillDismiss:(NmaTileMenuController *)tileMenu;
- (void)tileMenuDidDismiss:(NmaTileMenuController *)tileMenu action:(BOOL)action;

- (void)tileMenu:(NmaTileMenuController *)tileMenu didSelectTile:(NSInteger)tileNumber; // zero-based tileNumber
- (void)tileMenu:(NmaTileMenuController *)tileMenu didDeselectTile:(NSInteger)tileNumber; // zero-based tileNumber

- (BOOL)tileMenu:(NmaTileMenuController *)tileMenu shouldSwitchToPage:(NSInteger)pageNumber; // zero-based pageNumber
- (void)tileMenu:(NmaTileMenuController *)tileMenu willSwitchToPage:(NSInteger)pageNumber; // zero-based pageNumber
- (void)tileMenu:(NmaTileMenuController *)tileMenu didSwitchToPage:(NSInteger)pageNumber; // zero-based pageNumber

@end
