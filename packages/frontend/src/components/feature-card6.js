import React from 'react'

import PropTypes from 'prop-types'

import './feature-card6.css'

const FeatureCard6 = (props) => {
  return (
    <div className={`feature-card6-feature-card ${props.rootClassName} `}>
      <h2 className="feature-card6-text">{props.title}</h2>
      <img
        src="https://cryptologos.cc/logos/cartesi-ctsi-logo.svg?v=026"
        className="feature-card6-image"
      />
    </div>
  )
}

FeatureCard6.defaultProps = {
  rootClassName: '',
  title: 'CTSI',
  image_src:
    'https://images.unsplash.com/photo-1512295767273-ac109ac3acfa?ixid=Mnw5MTMyMXwwfDF8c2VhcmNofDF8fHllbGxvdyUyMHRlY2h8ZW58MHx8fHwxNjI2MjU1NDk0&ixlib=rb-1.2.1&w=200',
  image_alt: 'image',
}

FeatureCard6.propTypes = {
  rootClassName: PropTypes.string,
  title: PropTypes.string,
  image_src: PropTypes.string,
  image_alt: PropTypes.string,
}

export default FeatureCard6
