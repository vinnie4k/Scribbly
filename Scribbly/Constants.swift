//
//  Constants.swift
//  Scribbly
//
//  Created by Vin Bui on 12/18/22.
//
import UIKit

/**
 Constants for Design
 */
struct Constants {
    // ------------ Other ------------
    static let reuse = "Reuse"
    static let comment_reuse = "CommentReuse"
    
    // ------------ Home Page ------------
    static let border_top_padding = CGFloat(0)
    static let border_side_padding = CGFloat(15)
    static let prompt_heading_top_padding = CGFloat(20)
    static let prompt_top_padding = CGFloat(1)
    static let prompt_side_padding = CGFloat(20)
    static let profile_button_radius = CGFloat(20)
    static let friends_button_width = CGFloat(40)
    static let friends_button_height = CGFloat(30)
    static let logo_font = UIFont(descriptor: UIFont.systemFont(ofSize: 24, weight: .medium).fontDescriptor.withDesign(.rounded)!, size: 24)
    static let prompt_heading_font = UIFont(descriptor: UIFont.systemFont(ofSize: 12, weight: .medium).fontDescriptor.withDesign(.rounded)!, size: 12)
    static let prompt_font = UIFont(descriptor: UIFont.systemFont(ofSize: 40, weight: .bold).fontDescriptor.withDesign(.rounded)!, size: 40)
    static let user_post_corner = CGFloat(15)
    static let user_post_top_padding = CGFloat(20)
    static let user_post_side_padding = CGFloat(15)
    static let user_post_width = CGFloat(60)
    static let user_post_height = CGFloat(60)
    
    
    // ------------ PostCollectionView ------------
    static let post_cv_top_padding = CGFloat(15)
    static let post_cv_side_padding = CGFloat(15)
    static let post_container_width = UIScreen.main.bounds.width - 30 // DO NOT CHANGE THIS PLEASE
    static let post_container_height = CGFloat(325)
    static let post_container_spacing = CGFloat(15)
    
    // ------------ PostCollectionViewCell ------------
    static let post_cell_side_padding = CGFloat(10)
    static let post_cell_corner = CGFloat(15)
    static let post_cell_name_side = CGFloat(10)
    static let post_cell_drawing_height = UIScreen.main.bounds.width - 70   // KEEP THE UISCREEN.MAIN.BOUNDS STUFF
    static let post_cell_drawing_width = UIScreen.main.bounds.width - 70    // KEEP THE UISCREEN.MAIN.BOUNDS STUFF
    static let post_cell_drawing_corner = 0.1 * post_cell_drawing_width
    static let post_cell_drawing_border_width = CGFloat(7)
    static let post_cell_drawing_border_dark = UIColor(red: 18/255.0, green: 18/255.0, blue: 18/255.0, alpha: 1)
    static let post_cell_drawing_border_light = UIColor(red: 251/255.0, green: 251/255.0, blue: 251/255.0, alpha: 1)
    static let post_cell_btn_top = CGFloat(10)
    static let post_cell_btn_side = CGFloat(0)
    static let post_cell_stack_spacing = CGFloat(15)
    static let post_cell_stack_top = CGFloat(20)
    static let post_cell_stack_side = CGFloat(-3)
    static let post_cell_stack_corner = CGFloat(17)
    static let post_cell_pfp_side = CGFloat(10)
    static let post_cell_pfp_radius = CGFloat(15)
    static let post_cell_caption_top = CGFloat(2)
    static let post_cell_cap_view_bot = CGFloat(15)
    static let post_cell_cap_view_side = CGFloat(20)
    static let post_cell_cap_view_width = UIScreen.main.bounds.width - 110  // KEEP THE UISCREEN.MAIN.BOUNDS STUFF
    static let post_cell_cap_view_height = CGFloat(45)
    static let post_cell_cap_view_corner = CGFloat(20)
    static let post_cell_cap_view_light = UIColor(white: 1, alpha: 0.6)
    static let post_cell_cap_view_dark = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 0.6)
    static let post_cell_caption_font = UIFont(descriptor: UIFont.systemFont(ofSize: 10, weight: .light).fontDescriptor.withDesign(.rounded)!, size: 10)
    static let post_cell_username_font = UIFont(descriptor: UIFont.systemFont(ofSize: 14, weight: .bold).fontDescriptor.withDesign(.rounded)!, size: 14)
    
    // ------------ CommentVC ------------
    static let comment_title_font =  UIFont(descriptor: UIFont.systemFont(ofSize: 20, weight: .medium).fontDescriptor.withDesign(.rounded)!, size: 20)
    static let comment_drawing_height = UIScreen.main.bounds.width - 200   // KEEP THE UISCREEN.MAIN.BOUNDS STUFF
    static let comment_drawing_width = UIScreen.main.bounds.width - 200   // KEEP THE UISCREEN.MAIN.BOUNDS STUFF
    static let comment_drawing_corner = 0.1 * comment_drawing_width
    static let comment_drawing_top_padding = CGFloat(20)
    
    // ------------ CommentTableView ------------
    static let comment_tv_top_padding = CGFloat(15)
    static let comment_tv_side_padding = CGFloat(15)
    static let comment_container_width = UIScreen.main.bounds.width - 30 // DO NOT CHANGE THIS PLEASE
    static let comment_container_height = CGFloat(325)
    static let comment_container_spacing = CGFloat(15)
    
    // ------------ CommentHeaderView & CommentTableViewCell ------------
    static let comment_cell_pfp_radius = CGFloat(15)
    static let comment_cell_username_font = UIFont(descriptor: UIFont.systemFont(ofSize: 14, weight: .bold).fontDescriptor.withDesign(.rounded)!, size: 14)
    static let comment_cell_text_font = UIFont(descriptor: UIFont.systemFont(ofSize: 16, weight: .regular).fontDescriptor.withDesign(.rounded)!, size: 16)
    static let comment_cell_top = CGFloat(10)
    static let comment_cell_side = CGFloat(10)
    static let comment_cell_name_side = CGFloat(10)
    static let comment_cell_text_top = CGFloat(2)
    static let comment_cell_reply_top = CGFloat(0)
    static let comment_cell_reply_bot = CGFloat(0)
    static let reply_button_color = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)
    static let reply_button_font = UIFont(descriptor: UIFont.systemFont(ofSize: 16, weight: .medium).fontDescriptor.withDesign(.rounded)!, size: 16)
    static let comment_cell_corner = CGFloat(20)
    static let comment_cell_light = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    static let comment_cell_dark = UIColor(red: 0.071, green: 0.071, blue: 0.071, alpha: 1)
    static let comment_light_bg = UIColor(red: 0.983, green: 0.983, blue: 0.983, alpha: 1)
    static let comment_dark_bg = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    
}
