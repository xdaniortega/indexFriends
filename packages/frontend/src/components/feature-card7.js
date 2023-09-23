import React from 'react'

import PropTypes from 'prop-types'

import './feature-card7.css'

const FeatureCard7 = (props) => {
  return (
    <div className={`feature-card7-feature-card ${props.rootClassName} `}>
      <h2 className="feature-card7-text">{props.title}</h2>
      <img
        src="https://logosandtypes.com/wp-content/uploads/2022/03/1inch.svg"
        className="feature-card7-image"
      />
    </div>
  )
}

FeatureCard7.defaultProps = {
  image_src:
    'https://images.unsplash.com/photo-1512295767273-ac109ac3acfa?ixid=Mnw5MTMyMXwwfDF8c2VhcmNofDF8fHllbGxvdyUyMHRlY2h8ZW58MHx8fHwxNjI2MjU1NDk0&ixlib=rb-1.2.1&w=200',
  rootClassName: '',
  title: '1INCH',
  image_alt: 'image',
}

FeatureCard7.propTypes = {
  image_src: PropTypes.string,
  rootClassName: PropTypes.string,
  title: PropTypes.string,
  image_alt: PropTypes.string,
}

export default FeatureCard7
