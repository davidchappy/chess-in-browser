import React from 'react';
import renderer from 'react-test-renderer';
import { mount } from 'enzyme';
import Header from './header';
import Game from './header';

const props = {
  white: {
    is_playing: true
  },
  black: {
    is_playing: false
  },
  game: {
    status: 'check'
  }
}

describe('rendering Header (Snapshot Test)', () => {
  const component = renderer.create(<Header {...props} />);
  const json = component.toJSON();

  it('renders without crashing', () => {
    expect(json).toMatchSnapshot();
  });
});

describe('rendering Header in Welcome view', () => {
  const welcomeHeaderWrapper = mount(
    <Header welcome={true}/>
  );

  it('renders welcome text', () => {
    const h2 = welcomeHeaderWrapper.find('h2');
    expect(h2.text()).toBe('Welcome to Chess');
  });

  it('renders a large logo', () => {
    const logo = welcomeHeaderWrapper.find('img.chess-logo.large');
    expect(logo.length).toBe(1);
  });
});


describe('rendering Header in Game view', () => {
  const gameHeaderWrapper = mount(
    <Header headerSize='small' {...props} />
  );

  it('renders not heading text', () => {
    const h2 = gameHeaderWrapper.find('h2');
    expect(h2.length).toBe(0);
  });


  it('renders a logo', () => {
    const logo = gameHeaderWrapper.find('img.chess-logo.small');
    expect(logo.length).toBe(1);
  });
});