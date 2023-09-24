import React from 'react'

import PropTypes from 'prop-types'

import './testimonial-card2.css'

const TestimonialCard2 = (props) => {
  return (
    <div
      className={`testimonial-card2-testimonial-card ${props.rootClassName} `}
    >
      <div className="testimonial-card2-testimonial">
        <span className="testimonial-card2-text">{props.quote}</span>
      </div>
      <img
        src="https://github.com/xdaniortega/strategicWealth/blob/main/frontend/img/Nico_S_photorealistic_business_woman_attractive_white_backgroun_87802956-b1b9-44e5-8c33-f5c8b9f5c858.png"
        className="testimonial-card2-image"
      />
    </div>
  )
}

TestimonialCard2.defaultProps = {
  profile_src:
    'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixid=Mnw5MTMyMXwwfDF8c2VhcmNofDE0fHxwb3J0cmFpdHxlbnwwfHx8fDE2MjYzNzg5NzI&ixlib=rb-1.2.1&h=1200',
  quote: 'We have the best financial analysts doing the work for you',
  profile_alt: 'profile',
  name: 'John Doe',
  rootClassName: '',
}

TestimonialCard2.propTypes = {
  profile_src: PropTypes.string,
  quote: PropTypes.string,
  profile_alt: PropTypes.string,
  name: PropTypes.string,
  rootClassName: PropTypes.string,
}

export default TestimonialCard2
