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
        src="https://media.istockphoto.com/id/1163294201/photo/smiling-confident-businesswoman-posing-with-arms-folded.jpg?s=612x612&amp;w=0&amp;k=20&amp;c=9SY62tujbyx46_NbVH6pYAauliGvM0ixcaEfup9y_kU="
        className="testimonial-card2-image"
      />
    </div>
  )
}

TestimonialCard2.defaultProps = {
  rootClassName: '',
  quote: 'We have the best financial analysts doing the work for you',
  profile_src:
    'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixid=Mnw5MTMyMXwwfDF8c2VhcmNofDE0fHxwb3J0cmFpdHxlbnwwfHx8fDE2MjYzNzg5NzI&ixlib=rb-1.2.1&h=1200',
  profile_alt: 'profile',
  name: 'John Doe',
}

TestimonialCard2.propTypes = {
  rootClassName: PropTypes.string,
  quote: PropTypes.string,
  profile_src: PropTypes.string,
  profile_alt: PropTypes.string,
  name: PropTypes.string,
}

export default TestimonialCard2
