//
//  AnimationViewController.swift
//  Habit21
//
//  Created by MahyarShakouri on 1/23/22.
//

import UIKit

class AnimationViewController: UIViewController {

    let scrollView = UIScrollView()
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 5
        return pageControl
    } ()

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        view.addSubview(scrollView)
        view.addSubview(pageControl)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageControl.frame = CGRect(x: 10, y: view.frame.size.height-100, width: view.frame.size.width-20, height: 50)
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height+635)
        if scrollView.subviews.count == 2 {
            configureScrollView()
        }
    }

    func newVc(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }

    func configureScrollView(){
        scrollView.contentSize = CGSize(width: view.frame.size.width*5, height: view.frame.size.height)
        scrollView.isPagingEnabled = true
        let colors: [UIColor] = [
            UIColor.red,
            UIColor.yellow,
            UIColor.black,
            UIColor.green,
            UIColor.purple
        ]
        
        for x in 0..<5{
            let page = UIView(frame: CGRect(x:CGFloat(x) * view.frame.size.width, y:0, width: view.frame.size.width, height: scrollView.frame.size.height))
            page.backgroundColor = colors[x]
            scrollView.addSubview(page)

        }
    }
}

extension AnimationViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
    }

}
