import React from 'react'

import PropTypes from 'prop-types'

import './blog-post-card2.css'

const BlogPostCard2 = (props) => {
  return (
    <div className={`blog-post-card2-blog-post-card ${props.rootClassName} `}>
      <h1 className="blog-post-card2-text">{props.heading2}</h1>
      <img
        src={props.image_src}
        alt={props.image_alt1}
        className="blog-post-card2-image"
      />
      <div className="blog-post-card2-container">
        <div className="blog-post-card2-container1">
          <div className="blog-post-card2-profile">
            <button type="button" className="blog-post-card2-button button">
              {props.button}
            </button>
          </div>
          <div className="blog-post-card2-container2">
            <span className="blog-post-card2-text1">{props.text}</span>
            <span className="blog-post-card2-text2">{props.apy1}</span>
          </div>
          <div className="blog-post-card2-container3"></div>
        </div>
      </div>
    </div>
  )
}

BlogPostCard2.defaultProps = {
  rootClassName: '',
  apy1: '100k TVL',
  heading: 'IndexFriend # 1',
  button: 'Deposit',
  image_alt: 'image',
  heading1: 'IndexFriend #33',
  heading2: 'IndexFriend #3',
  text: '20% APY',
  image_alt1: 'image',
  image_src: 'https://nftevening.com/wp-content/uploads/2021/10/unnamed-3.png',
}

BlogPostCard2.propTypes = {
  rootClassName: PropTypes.string,
  apy1: PropTypes.string,
  heading: PropTypes.string,
  button: PropTypes.string,
  image_alt: PropTypes.string,
  heading1: PropTypes.string,
  heading2: PropTypes.string,
  text: PropTypes.string,
  image_alt1: PropTypes.string,
  image_src: PropTypes.string,
}

export default BlogPostCard2
