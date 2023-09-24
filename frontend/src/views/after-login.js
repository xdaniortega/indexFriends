import React from 'react'
import { Link } from 'react-router-dom'

import { Helmet } from 'react-helmet'

import BlogPostCard2 from '../components/blog-post-card2'
import TestimonialCard2 from '../components/testimonial-card2'
import './after-login.css'

const AfterLogin = (props) => {
  return (
    <div className="after-login-container">
      <Helmet>
        <title>After-login - Character NFT template</title>
        <meta
          property="og:title"
          content="After-login - Character NFT template"
        />
      </Helmet>
      <header data-thq="thq-navbar" className="after-login-navbar">
        <img
          src="https://ipfs.io/ipfs/QmZJtxZVKeGUg25J5agroDSFMM2MaKgq8gCquQ1knNTkZr"
          alt="image"
          className="after-login-image"
        />
        <span className="after-login-logo">Index Friends</span>
        <div
          data-thq="thq-navbar-nav"
          data-role="Nav"
          className="after-login-desktop-menu"
        ></div>
        <div data-thq="thq-navbar-btn-group" className="after-login-btn-group">
          <div className="after-login-socials"></div>
         <button className="after-login-view button">
            <w3m-button />
          </button>         </div>
        <div data-thq="thq-burger-menu" className="after-login-burger-menu">
          <button className="button after-login-button">
            <svg viewBox="0 0 1024 1024" className="after-login-icon">
              <path d="M128 554.667h768c23.552 0 42.667-19.115 42.667-42.667s-19.115-42.667-42.667-42.667h-768c-23.552 0-42.667 19.115-42.667 42.667s19.115 42.667 42.667 42.667zM128 298.667h768c23.552 0 42.667-19.115 42.667-42.667s-19.115-42.667-42.667-42.667h-768c-23.552 0-42.667 19.115-42.667 42.667s19.115 42.667 42.667 42.667zM128 810.667h768c23.552 0 42.667-19.115 42.667-42.667s-19.115-42.667-42.667-42.667h-768c-23.552 0-42.667 19.115-42.667 42.667s19.115 42.667 42.667 42.667z"></path>
            </svg>
          </button>
        </div>
        <div data-thq="thq-mobile-menu" className="after-login-mobile-menu">
          <div
            data-thq="thq-mobile-menu-nav"
            data-role="Nav"
            className="after-login-nav"
          >
            <div className="after-login-container01">
              <span className="after-login-logo1">Character</span>
              <div data-thq="thq-close-menu" className="after-login-menu-close">
                <svg viewBox="0 0 1024 1024" className="after-login-icon02">
                  <path d="M810 274l-238 238 238 238-60 60-238-238-238 238-60-60 238-238-238-238 60-60 238 238 238-238z"></path>
                </svg>
              </div>
            </div>
            <nav
              data-thq="thq-mobile-menu-nav-links"
              data-role="Nav"
              className="after-login-nav1"
            >
              <span className="after-login-text">About</span>
              <span className="after-login-text1">Features</span>
              <span className="after-login-text2">Pricing</span>
              <span className="after-login-text3">Team</span>
              <span className="after-login-text4">Blog</span>
            </nav>
            <div className="after-login-container02">
              <button className="after-login-login button">Login</button>
              <button className="button">Register</button>
            </div>
          </div>
          <div className="after-login-icon-group">
            <svg
              viewBox="0 0 950.8571428571428 1024"
              className="after-login-icon04"
            >
              <path d="M925.714 233.143c-25.143 36.571-56.571 69.143-92.571 95.429 0.571 8 0.571 16 0.571 24 0 244-185.714 525.143-525.143 525.143-104.571 0-201.714-30.286-283.429-82.857 14.857 1.714 29.143 2.286 44.571 2.286 86.286 0 165.714-29.143 229.143-78.857-81.143-1.714-149.143-54.857-172.571-128 11.429 1.714 22.857 2.857 34.857 2.857 16.571 0 33.143-2.286 48.571-6.286-84.571-17.143-148-91.429-148-181.143v-2.286c24.571 13.714 53.143 22.286 83.429 23.429-49.714-33.143-82.286-89.714-82.286-153.714 0-34.286 9.143-65.714 25.143-93.143 90.857 112 227.429 185.143 380.571 193.143-2.857-13.714-4.571-28-4.571-42.286 0-101.714 82.286-184.571 184.571-184.571 53.143 0 101.143 22.286 134.857 58.286 41.714-8 81.714-23.429 117.143-44.571-13.714 42.857-42.857 78.857-81.143 101.714 37.143-4 73.143-14.286 106.286-28.571z"></path>
            </svg>
            <svg
              viewBox="0 0 877.7142857142857 1024"
              className="after-login-icon06"
            >
              <path d="M585.143 512c0-80.571-65.714-146.286-146.286-146.286s-146.286 65.714-146.286 146.286 65.714 146.286 146.286 146.286 146.286-65.714 146.286-146.286zM664 512c0 124.571-100.571 225.143-225.143 225.143s-225.143-100.571-225.143-225.143 100.571-225.143 225.143-225.143 225.143 100.571 225.143 225.143zM725.714 277.714c0 29.143-23.429 52.571-52.571 52.571s-52.571-23.429-52.571-52.571 23.429-52.571 52.571-52.571 52.571 23.429 52.571 52.571zM438.857 152c-64 0-201.143-5.143-258.857 17.714-20 8-34.857 17.714-50.286 33.143s-25.143 30.286-33.143 50.286c-22.857 57.714-17.714 194.857-17.714 258.857s-5.143 201.143 17.714 258.857c8 20 17.714 34.857 33.143 50.286s30.286 25.143 50.286 33.143c57.714 22.857 194.857 17.714 258.857 17.714s201.143 5.143 258.857-17.714c20-8 34.857-17.714 50.286-33.143s25.143-30.286 33.143-50.286c22.857-57.714 17.714-194.857 17.714-258.857s5.143-201.143-17.714-258.857c-8-20-17.714-34.857-33.143-50.286s-30.286-25.143-50.286-33.143c-57.714-22.857-194.857-17.714-258.857-17.714zM877.714 512c0 60.571 0.571 120.571-2.857 181.143-3.429 70.286-19.429 132.571-70.857 184s-113.714 67.429-184 70.857c-60.571 3.429-120.571 2.857-181.143 2.857s-120.571 0.571-181.143-2.857c-70.286-3.429-132.571-19.429-184-70.857s-67.429-113.714-70.857-184c-3.429-60.571-2.857-120.571-2.857-181.143s-0.571-120.571 2.857-181.143c3.429-70.286 19.429-132.571 70.857-184s113.714-67.429 184-70.857c60.571-3.429 120.571-2.857 181.143-2.857s120.571-0.571 181.143 2.857c70.286 3.429 132.571 19.429 184 70.857s67.429 113.714 70.857 184c3.429 60.571 2.857 120.571 2.857 181.143z"></path>
            </svg>
            <svg
              viewBox="0 0 602.2582857142856 1024"
              className="after-login-icon08"
            >
              <path d="M548 6.857v150.857h-89.714c-70.286 0-83.429 33.714-83.429 82.286v108h167.429l-22.286 169.143h-145.143v433.714h-174.857v-433.714h-145.714v-169.143h145.714v-124.571c0-144.571 88.571-223.429 217.714-223.429 61.714 0 114.857 4.571 130.286 6.857z"></path>
            </svg>
          </div>
        </div>
      </header>
      <div className="after-login-banner">
        <h1 className="after-login-text5">Effortless investing starts here!</h1>
        <span className="after-login-text6">
          <span>
            <span
              dangerouslySetInnerHTML={{
                __html: ' ',
              }}
            />
          </span>
          <span>
            <span
              dangerouslySetInnerHTML={{
                __html: ' ',
              }}
            />
          </span>
        </span>
        <div className="after-login-blog">
          <div className="after-login-container03">
            <BlogPostCard2
              rootClassName="rootClassName3"
              heading2="IndexFriend #3"
              text="12% APY"
              image_alt="https://fuchsia-far-hedgehog-697.mypinata.cloud/ipfs/QmZ4RkhPkkL1gBNgHTFRahi8EMhRyGi8tZdayJUSVdm4Y4/one.png"
              image_src="https://fuchsia-far-hedgehog-697.mypinata.cloud/ipfs/Qma6ZgH9ReXhNHL9KYmvmzVfswoLoyYsndFcqiw36HRhoH/"
            ></BlogPostCard2>
          </div>
          <div className="after-login-container04">
            <BlogPostCard2
              image_src="https://fuchsia-far-hedgehog-697.mypinata.cloud/ipfs/QmekdqwuSjBJuGiKtbeDWKynvdyXCPSdTDkt2iB74Y2Ru6/"
              rootClassName="rootClassName8"
              heading1="IndexFriend #12"
              heading2="IndexFriend #21"
              text="18% APY"
              apy1="150k TVL"
            ></BlogPostCard2>
          </div>
          <div className="after-login-container05">
            <BlogPostCard2
              image_src="https://fuchsia-far-hedgehog-697.mypinata.cloud/ipfs/Qmcp2x7nnxg5qPGVx2mkpxUjrrqmG1pHi9rAYQqGWtZfdR/"
              rootClassName="rootClassName1"
              heading2="IndexFriend #8"
              apy1="200k TVL"
              text="21% APY"
            ></BlogPostCard2>
          </div>
        </div>
        <div className="after-login-blog1">
          <div className="after-login-container06">
            <BlogPostCard2
              rootClassName="rootClassName5"
              heading2="IndexFriend #25"
              apy1="80k TVL"
              text="19% APY"
              image_src="https://fuchsia-far-hedgehog-697.mypinata.cloud/ipfs/QmRukLcrV7KeenaXqz6aiskpGchcnRMCcLu8oreYoNTUS1/"
            ></BlogPostCard2>
          </div>
          <div className="after-login-container07">
            <Link to="/balance" className="after-login-navlink">
              <BlogPostCard2
                image_src="https://fuchsia-far-hedgehog-697.mypinata.cloud/ipfs/QmZptwopXNSLCg9zxAuSmYFsuQw5k9yrgLg9NhXu73Gn9a/"
                rootClassName="rootClassName6"
                heading2="IndexFriend #7"
                text="22% APY"
                apy1="200k TVL"
                className="after-login-component2"
              ></BlogPostCard2>
            </Link>
          </div>
          <div className="after-login-container08">
            <BlogPostCard2
              image_src="https://fuchsia-far-hedgehog-697.mypinata.cloud/ipfs/QmNxApxMCQG4BV2n6k7iiB7xzq6uK3VaS2K1Q9n7uPd24L/"
              rootClassName="rootClassName7"
              heading2="IndexFriend #9"
              apy1="130k TVL"
              text="23% APY"
            ></BlogPostCard2>
          </div>
        </div>
        <div className="after-login-testimonial">
          <div className="after-login-container09">
            <div className="after-login-container10">
              <div className="after-login-container11">
                <TestimonialCard2
                  profile_src="https://ipfs.io/ipfs/QmQLpe8NLVbJoxgEpro7uhfzQSLToNyoXXq4F3NK8cm89g"
                  rootClassName="rootClassName1"
                ></TestimonialCard2>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default AfterLogin
