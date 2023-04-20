//
//  PageControlViewController.swift
//  Habit21
//
//  Created by MahyarShakouri on 2/16/22.
//

import UIKit

class PageControlViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
 
    var pages : [ScrollView] {
        get {
            let page1: ScrollView = Bundle.main.loadNibNamed("ScrollView", owner: self, options: nil)?.first as! ScrollView
            page1.habitImage.image = UIImage(named: "HealtyHabit")
            page1.titleLabel.text = "Introduce Healty Habits"
            page1.descriptionLable.text = "There's nothing you can't do if you get the habits right. Introduce a healty habit in your life with Habit21."
            page1.descriptionLable.attributedText = justifyLabel(str: page1.descriptionLable.text!)
            page1.nextButton.setTitle("", for: .normal)
        
            let page2: ScrollView = Bundle.main.loadNibNamed("ScrollView", owner: self, options: nil)?.first as! ScrollView
            page2.habitImage.image = UIImage(named: "BadHabit")
            page2.titleLabel.text = "Throw Away Bad Habits"
            page2.descriptionLable.text = "You can change a bad habit by replacing it with a good habit. This app alows you to do that witch Habit21."
            page2.descriptionLable.attributedText = justifyLabel(str: page2.descriptionLable.text!)
            page2.nextButton.setTitle("Next", for: .normal)
            page2.nextButton.addTarget(self, action:#selector(handleRegister), for: .touchUpInside)
            return [page1, page2]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for:  .valueChanged)
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        view.bringSubviewToFront(pageControl)
        
        setupScrollView(pages: pages)
        
        self.scrollView.contentSize.height = 1.0
    }
    
    @objc func handleRegister() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.navigationController?.show(vc!, sender: nil)
    }
    
    @objc private func pageControlDidChange(_ sender: UIPageControl){
        let current = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: CGFloat(current) * view.frame.size.width, y: 0), animated: true)
    }
    
    func setupScrollView(pages: [ScrollView]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(pages.count), height: view.frame.height)
        scrollView.isPagingEnabled = true

        for i in 0 ..< pages.count {
            pages[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(pages[i])
        }
    }
    
    func justifyLabel(str: String) -> NSAttributedString
    {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = NSTextAlignment.justified
    let attributedString = NSAttributedString(string: str,
                                              attributes: [
                                                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                                                NSAttributedString.Key.baselineOffset: NSNumber(value: 0)
        ])
    return attributedString
    }
}

extension PageControlViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}



