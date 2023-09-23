import React from "react";
import { Link } from "react-router-dom";

import { Helmet } from "react-helmet";

import TestimonialCard2 from "../components/testimonial-card2";
import GalleryCard1 from "../components/gallery-card1";
import "./after-login.css";

const AfterLogin = (props) => {
  return (
    <div className="after-login-container">
      <Helmet>
        <title>WealthStrategists</title>
        <meta
          property="og:title"
          content="After-login - Character NFT template"
        />
      </Helmet>
      <header data-thq="thq-navbar" className="after-login-navbar">
        <span className="after-login-logo">WealthStrategists</span>
        <div
          data-thq="thq-navbar-nav"
          data-role="Nav"
          className="after-login-desktop-menu"
        ></div>
        <div data-thq="thq-navbar-btn-group" className="after-login-btn-group">
          <div className="after-login-socials"></div>
          <button className="after-login-view button">
            <w3m-button />
          </button>
        </div>
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
            <div className="after-login-container1">
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
              <span className="after-login-text01">Features</span>
              <span className="after-login-text02">Pricing</span>
              <span className="after-login-text03">Team</span>
              <span className="after-login-text04">Blog</span>
            </nav>
            <div className="after-login-container2">
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
        <h1 className="after-login-text05">Start investing easily</h1>
        <span className="after-login-text06">
          <span>
            <span
              dangerouslySetInnerHTML={{
                __html: " ",
              }}
            />
          </span>
          <span>
            <span
              dangerouslySetInnerHTML={{
                __html: " ",
              }}
            />
          </span>
        </span>
        <div className="after-login-pricing-card">
          <Link to="/balance" className="after-login-navlink button">
            Deposit
          </Link>
          <div className="after-login-container3">
            <span className="after-login-text09">Expected return:</span>
            <span className="after-login-text10">5%</span>
            <span className="after-login-text11">
              with our investment strategy
            </span>
          </div>
          <div className="after-login-container4"></div>
        </div>
        <div className="after-login-testimonial">
          <div className="after-login-container5">
            <div className="after-login-container6">
              <div className="after-login-container7">
                <TestimonialCard2
                  profile_src="https://images.unsplash.com/photo-1614630982169-e89202c5e045?ixid=Mnw5MTMyMXwwfDF8c2VhcmNofDIwfHxtYWxlJTIwcG9ydHJhaXR8ZW58MHx8fHwxNjI2NDUyMTk4&amp;ixlib=rb-1.2.1&amp;h=1200"
                  rootClassName="rootClassName1"
                ></TestimonialCard2>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div className="after-login-container8">
        <div className="after-login-gallery">
          <GalleryCard1
            rootClassName="rootClassName"
            image_src="https://images.contentstack.io/v3/assets/blt38dd155f8beb7337/bltf9318a010cf6157a/62bbd041a7c4490fd2ef1bd9/Bored_Ape_Yacht_Club.png"
            title="10% TVL"
          ></GalleryCard1>
          <GalleryCard1
            image_src="https://lh3.googleusercontent.com/RTvkOSzBsTG0E54t8g4MyXTxETwoIy-91kYLIogGPZx05TX751dRAB7AOSrS74t5Yykay8LuCzy4Ep9UsTaOotYr5lBvpu_oEGoe"
            rootClassName="rootClassName1"
            title="15 % TVL"
          ></GalleryCard1>
          <GalleryCard1
            image_src="https://lh3.googleusercontent.com/2Z79aJhV8IG4INHBevcZ-xAxNEe3BvaeJTzUFfrU--SkHS4d24vIbIvjfeajTiZzcY3_hDlWcc0bXBMVVDxYnQH_RtfkbrEUHlw=s1000"
            rootClassName="rootClassName2"
            title="18 % TVL"
          ></GalleryCard1>
          <GalleryCard1
            image_src="https://airnfts.s3.amazonaws.com/nft-images/Bored_Ape_Yacht_Club_1619928448096.png"
            rootClassName="rootClassName3"
            title="20 % TVL"
          ></GalleryCard1>
          <GalleryCard1
            image_src="https://global-uploads.webflow.com/61a98989a418f6f2acefef70/62aa03c8f2dea34dffb75da3_Bored%20Ape%20Yacht%20Club%20NFTs%20Drop%20Below%20%24100K%20for%20First%20Time%20since%20August%E2%80%8D.JPG"
            rootClassName="rootClassName4"
            title="21 % TVL"
          ></GalleryCard1>
          <GalleryCard1
            image_src="https://nftevening.com/wp-content/uploads/2021/10/unnamed-3.png"
            rootClassName="rootClassName5"
            title="25 % TVL"
          ></GalleryCard1>
        </div>
        <h1 className="after-login-text12">Let top players play for you</h1>
      </div>
    </div>
  );
};

export default AfterLogin;
