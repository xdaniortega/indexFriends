import React from 'react'

import PropTypes from 'prop-types'

import './feature-card5.css'

const FeatureCard5 = (props) => {
  return (
    <div className={`feature-card5-feature-card ${props.rootClassName} `}>
      <h2 className="feature-card5-text">{props.title}</h2>
      <img
        src="https://upload.wikimedia.org/wikipedia/commons/e/e7/Uniswap_Logo.svg"
        className="feature-card5-image"
      />
    </div>
  )
}

FeatureCard5.defaultProps = {
  image_src:
    'https://images.unsplash.com/photo-1512295767273-ac109ac3acfa?ixid=Mnw5MTMyMXwwfDF8c2VhcmNofDF8fHllbGxvdyUyMHRlY2h8ZW58MHx8fHwxNjI2MjU1NDk0&ixlib=rb-1.2.1&w=200',
  title: 'UNI',
  image_alt: 'image',
  rootClassName: '',
}

FeatureCard5.propTypes = {
  image_src: PropTypes.string,
  title: PropTypes.string,
  image_alt: PropTypes.string,
  rootClassName: PropTypes.string,
}

export default FeatureCard5
