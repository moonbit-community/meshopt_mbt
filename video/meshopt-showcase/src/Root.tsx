import {Composition} from 'remotion';
import {MeshoptimizerShowcase} from './Showcase';

export const RemotionRoot = () => {
  return (
    <Composition
      id="MeshoptimizerShowcase"
      component={MeshoptimizerShowcase}
      durationInFrames={450}
      fps={30}
      width={1920}
      height={1080}
    />
  );
};
