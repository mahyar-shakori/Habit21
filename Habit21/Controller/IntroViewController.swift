//
//  AddNameViewController.swift
//  Habit21
//
//  Created by MahyarShakouri on 2/15/22.
//

import UIKit

class IntroViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
        }
    }
    
    var pageIndexFlag: Int!
    var slides:[Slide] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleView()
    }
    
    func handleView() {
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        //        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for:  .valueChanged)
        nextButton.addCornerView(corner: 20)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
        
        self.scrollView.contentSize.height = 200
    }
    
    @objc func nextButtonTapped(_ sender: Any) {
        
        skipButton.isHidden = true
        
        if pageIndexFlag == 1 {
            let storyBoard : UIStoryboard = self.storyboard!
            let vc = storyBoard.instantiateViewController(withIdentifier: "SetName") as! SetNameViewController
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.show(vc, sender: nil)
        } else {
            scrollView.contentOffset.x +=  self.view.bounds.width
        }
    }
    
    @objc func skipButtonTapped(_ sender: Any) {
        
        let storyBoard : UIStoryboard = self.storyboard!
        let vc = storyBoard.instantiateViewController(withIdentifier: "SetName") as! SetNameViewController
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.show(vc, sender: nil)
    }
    
    //    @objc private func pageControlDidChange(_ sender: UIPageControl){
    //
    //        let current = sender.currentPage
    //        scrollView.setContentOffset(CGPoint(x: CGFloat(current) * view.frame.size.width, y: 0), animated: true)
    //    }
    
    func createSlides() -> [Slide] {
        
        let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide1.imageView.image = UIImage(named: "HealtyHabit")
        slide1.titleLabel.text = "Introduce Healty Habits"
        slide1.descriptionLabel.text = "It is estimated that it takes 21 days for people to form a new habit. Introduce a healthy habit in your life with the 21 days app."
        slide1.descriptionLabel.attributedText = justifyLabel(str: slide1.descriptionLabel.text!)
        
        let slide2:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide2.imageView.image = UIImage(named: "BadHabit")
        slide2.titleLabel.text = "Throw Away Bad Habits"
        slide2.descriptionLabel.text = "Don't forget to take care of your body. You can change a bad habit by replacing it with a good habit, you can do it with this 21 Days app."
        slide2.descriptionLabel.attributedText = justifyLabel(str: slide2.descriptionLabel.text!)
        
        return [slide1, slide2]
    }
    
    func setupSlideScrollView(slides : [Slide]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        pageIndexFlag = Int(pageIndex)
        
        if pageIndexFlag == 0 {
            skipButton.isHidden = false
        } else {
            skipButton.isHidden = true
        }
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        
        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        
        slides[0].imageView.transform = CGAffineTransform(scaleX: (1-percentOffset.x)/1, y: (1-percentOffset.x)/1)
        
        slides[1].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/1, y: percentOffset.x/1)
    }
    
    func scrollView(_ scrollView: UIScrollView, didScrollToPercentageOffset percentageHorizontalOffset: CGFloat) {
        if(pageControl.currentPage == 0) {
            
            let pageUnselectedColor: UIColor = fade(fromRed: 255/255, fromGreen: 255/255, fromBlue: 255/255, fromAlpha: 1, toRed: 103/255, toGreen: 58/255, toBlue: 183/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            pageControl.pageIndicatorTintColor = pageUnselectedColor
            
            let bgColor: UIColor = fade(fromRed: 103/255, fromGreen: 58/255, fromBlue: 183/255, fromAlpha: 1, toRed: 255/255, toGreen: 255/255, toBlue: 255/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            slides[pageControl.currentPage].backgroundColor = bgColor
            
            let pageSelectedColor: UIColor = fade(fromRed: 81/255, fromGreen: 36/255, fromBlue: 152/255, fromAlpha: 1, toRed: 103/255, toGreen: 58/255, toBlue: 183/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            pageControl.currentPageIndicatorTintColor = pageSelectedColor
        }
    }
    
    func fade(fromRed: CGFloat,
              fromGreen: CGFloat,
              fromBlue: CGFloat,
              fromAlpha: CGFloat,
              toRed: CGFloat,
              toGreen: CGFloat,
              toBlue: CGFloat,
              toAlpha: CGFloat,
              withPercentage percentage: CGFloat) -> UIColor {
        
        let red: CGFloat = (toRed - fromRed) * percentage + fromRed
        let green: CGFloat = (toGreen - fromGreen) * percentage + fromGreen
        let blue: CGFloat = (toBlue - fromBlue) * percentage + fromBlue
        let alpha: CGFloat = (toAlpha - fromAlpha) * percentage + fromAlpha
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func justifyLabel(str: String) -> NSAttributedString
    {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.justified
        paragraphStyle.lineSpacing = 3
        let attributedString = NSAttributedString(string: str,
                                                  attributes: [
                                                    NSAttributedString.Key.paragraphStyle: paragraphStyle,
                                                    NSAttributedString.Key.baselineOffset: NSNumber(value: 0)
                                                  ])
        return attributedString
    }
}
