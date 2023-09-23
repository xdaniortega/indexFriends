import React from 'react'

import PropTypes from 'prop-types'

import './feature-card8.css'

const FeatureCard8 = (props) => {
  return (
    <div className={`feature-card8-feature-card ${props.rootClassName} `}>
      <h2 className="feature-card8-text">{props.title}</h2>
      <img
        src="https://cryptologos.cc/logos/chainlink-link-logo.png?v=002"
        className="feature-card8-image"
      />
    </div>
  )
}

FeatureCard8.defaultProps = {
  image_src:
    'https://images.unsplash.com/photo-1512295767273-ac109ac3acfa?ixid=Mnw5MTMyMXwwfDF8c2VhcmNofDF8fHllbGxvdyUyMHRlY2h8ZW58MHx8fHwxNjI2MjU1NDk0&ixlib=rb-1.2.1&w=200',
  image_alt: 'image',
  title: 'LINK',
  rootClassName: '',
}

FeatureCard8.propTypes = {
  image_src: PropTypes.string,
  image_alt: PropTypes.string,
  title: PropTypes.string,
  rootClassName: PropTypes.string,
}

export default FeatureCard8
