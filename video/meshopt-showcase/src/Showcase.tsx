import React from 'react';
import {
  AbsoluteFill,
  Easing,
  interpolate,
  useCurrentFrame,
} from 'remotion';

const font =
  'Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif';
const mono = 'Menlo, Consolas, "SFMono-Regular", monospace';

type Point3 = [number, number, number];
type Point2 = {x: number; y: number};

const points3d: Point3[] = [
  [-1.2, -0.78, -0.72],
  [0.95, -0.85, -0.6],
  [1.22, 0.62, -0.66],
  [-0.98, 0.86, -0.7],
  [-0.88, -0.62, 0.96],
  [0.9, -0.68, 1.04],
  [1.02, 0.72, 0.92],
  [-0.96, 0.68, 1.02],
  [-0.18, 0.08, 1.38],
  [0.16, -0.02, -1.22],
  [-0.58, 0.14, 0.18],
  [0.54, -0.18, 0.1],
];

const baseEdges: [number, number][] = [
  [0, 1],
  [1, 2],
  [2, 3],
  [3, 0],
  [4, 5],
  [5, 6],
  [6, 7],
  [7, 4],
  [0, 4],
  [1, 5],
  [2, 6],
  [3, 7],
  [4, 8],
  [5, 8],
  [6, 8],
  [7, 8],
  [0, 9],
  [1, 9],
  [2, 9],
  [3, 9],
  [10, 11],
  [10, 3],
  [11, 6],
];

const simplifiedEdges: [number, number][] = [
  [0, 1],
  [1, 2],
  [2, 6],
  [6, 7],
  [7, 4],
  [4, 0],
  [1, 5],
  [5, 8],
  [8, 6],
  [0, 7],
];

const rawPath = [2, 7, 1, 6, 0, 8, 3, 5, 10, 4, 11, 9];
const cachePath = [0, 1, 5, 4, 7, 3, 2, 6, 8, 11, 10, 9];

const clusters = [
  {edges: [[0, 1], [1, 5], [5, 4], [4, 0]], color: '#5eead4'},
  {edges: [[1, 2], [2, 6], [6, 5], [5, 1]], color: '#a3e635'},
  {edges: [[4, 5], [5, 8], [8, 7], [7, 4]], color: '#facc15'},
  {edges: [[2, 3], [3, 7], [7, 6], [6, 2]], color: '#fb7185'},
] as const;

const clamp = (value: number, min = 0, max = 1) =>
  Math.min(max, Math.max(min, value));

const ease = (frame: number, start: number, end: number) =>
  interpolate(frame, [start, end], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.bezier(0.16, 1, 0.3, 1),
  });

const fadeScene = (frame: number, start: number, end: number) =>
  clamp(Math.min(ease(frame, start, start + 10), 1 - ease(frame, end - 10, end)));

const rotate = ([x, y, z]: Point3, angle: number): Point3 => {
  const cy = Math.cos(angle);
  const sy = Math.sin(angle);
  const cx = Math.cos(angle * 0.56);
  const sx = Math.sin(angle * 0.56);
  const rx = x * cy + z * sy;
  const rz = -x * sy + z * cy;
  const ry = y * cx - rz * sx;
  const rz2 = y * sx + rz * cx;
  return [rx, ry, rz2];
};

const project = (point: Point3, size: number): Point2 => {
  const [x, y, z] = point;
  const depth = 4.35 + z;
  const scale = size / depth;
  return {x: x * scale, y: y * scale};
};

const projectedPoints = (frame: number, size: number) => {
  const angle = frame * 0.024 - 0.45;
  return points3d.map((point) => project(rotate(point, angle), size));
};

const Background = () => {
  const frame = useCurrentFrame();
  const offset = -(frame * 0.22) % 64;

  return (
    <AbsoluteFill
      style={{
        background:
          'linear-gradient(135deg, #07120f 0%, #11150f 50%, #171019 100%)',
        overflow: 'hidden',
      }}
    >
      <svg width="1920" height="1080" style={{position: 'absolute', inset: 0}}>
        <defs>
          <pattern id="grid" width="64" height="64" patternUnits="userSpaceOnUse">
            <path
              d="M 64 0 L 0 0 0 64"
              fill="none"
              stroke="#ffffff"
              strokeOpacity="0.045"
            />
          </pattern>
          <linearGradient id="beam" x1="0" x2="1" y1="0" y2="1">
            <stop offset="0" stopColor="#5eead4" stopOpacity="0.13" />
            <stop offset="0.55" stopColor="#a3e635" stopOpacity="0.1" />
            <stop offset="1" stopColor="#fb7185" stopOpacity="0.1" />
          </linearGradient>
        </defs>
        <rect
          width="1920"
          height="1080"
          fill="url(#grid)"
          transform={`translate(${offset} ${offset})`}
        />
        <path
          d="M -120 700 C 330 500 650 780 1010 550 S 1550 410 2070 620"
          fill="none"
          stroke="url(#beam)"
          strokeWidth="3"
          strokeOpacity="0.36"
        />
      </svg>
    </AbsoluteFill>
  );
};

const edgeLine = (
  points: Point2[],
  [from, to]: readonly [number, number],
  color: string,
  opacity: number,
  width: number,
  key: string,
) => (
  <line
    key={key}
    x1={points[from].x}
    y1={points[from].y}
    x2={points[to].x}
    y2={points[to].y}
    stroke={color}
    strokeLinecap="round"
    strokeOpacity={opacity}
    strokeWidth={width}
  />
);

const MeshBase = ({
  points,
  edges,
  color,
  opacity = 0.5,
  width = 2.5,
}: {
  points: Point2[];
  edges: [number, number][];
  color: string;
  opacity?: number;
  width?: number;
}) => (
  <>
    {edges.map((line, i) => edgeLine(points, line, color, opacity, width, `e-${i}`))}
    {points.map((point, i) => (
      <circle
        key={i}
        cx={point.x}
        cy={point.y}
        r={i >= 8 ? 5.2 : 7.4}
        fill={i % 3 === 0 ? '#5eead4' : '#a3e635'}
        opacity={i >= 8 ? 0.62 : 0.9}
      />
    ))}
  </>
);

const PathLines = ({
  points,
  order,
  color,
  progress,
}: {
  points: Point2[];
  order: number[];
  color: string;
  progress: number;
}) => {
  const visible = Math.floor(progress * (order.length - 1));
  const opacity = clamp(progress * 1.2);

  return (
    <>
      {order.slice(0, visible).map((from, i) =>
        edgeLine(points, [from, order[i + 1]], color, opacity, 6, `p-${color}-${i}`),
      )}
      {order.slice(0, visible + 1).map((index, i) => (
        <circle
          key={`dot-${color}-${i}`}
          cx={points[index].x}
          cy={points[index].y}
          r={10}
          fill={color}
          opacity={0.34 + opacity * 0.42}
        />
      ))}
    </>
  );
};

const SceneShell = ({
  title,
  api,
  opacity,
  children,
}: {
  title: string;
  api: string;
  opacity: number;
  children: React.ReactNode;
}) => (
  <AbsoluteFill
    style={{
      opacity,
      color: '#f8fafc',
      fontFamily: font,
    }}
  >
    <div
      style={{
        position: 'absolute',
        top: 54,
        left: 0,
        right: 0,
        textAlign: 'center',
        fontSize: 54,
        fontWeight: 950,
        letterSpacing: 0,
      }}
    >
      {title}
    </div>
    <div
      style={{
        position: 'absolute',
        inset: '130px 0 178px 0',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
      }}
    >
      {children}
    </div>
    <div
      style={{
        position: 'absolute',
        left: 0,
        right: 0,
        bottom: 56,
        textAlign: 'center',
        fontFamily: mono,
        fontSize: 44,
        fontWeight: 850,
        color: '#d9f99d',
      }}
    >
      {api}
    </div>
  </AbsoluteFill>
);

const CacheScene = ({opacity}: {opacity: number}) => {
  const frame = useCurrentFrame();
  const local = frame;
  const points = projectedPoints(frame, 760);
  const rawProgress = 1 - ease(local, 34, 78);
  const cacheProgress = ease(local, 45, 105);

  return (
    <SceneShell
      title="vertex cache optimization"
      api="@meshopt_mbt.optimize_vertex_cache"
      opacity={opacity}
    >
      <svg width="840" height="650" viewBox="-420 -325 840 650">
        <circle r="296" fill="#a3e635" opacity="0.045" />
        <circle r="236" fill="none" stroke="#a3e635" strokeOpacity="0.14" strokeWidth="2" />
        <MeshBase points={points} edges={baseEdges} color="#7dd3fc" opacity={0.22} />
        <PathLines points={points} order={rawPath} color="#fb7185" progress={rawProgress} />
        <PathLines points={points} order={cachePath} color="#a3e635" progress={cacheProgress} />
      </svg>
    </SceneShell>
  );
};

const SimplifyScene = ({opacity}: {opacity: number}) => {
  const frame = useCurrentFrame();
  const local = frame - 120;
  const points = projectedPoints(frame, 760);
  const progress = ease(local, 18, 90);
  const denseOpacity = 0.48 * (1 - progress);
  const cleanOpacity = 0.18 + progress * 0.82;

  return (
    <SceneShell
      title="mesh simplification / LOD"
      api="@meshopt_mbt.simplify"
      opacity={opacity}
    >
      <svg width="840" height="650" viewBox="-420 -325 840 650">
        <circle r="296" fill="#a3e635" opacity="0.045" />
        <circle r="236" fill="none" stroke="#a3e635" strokeOpacity="0.14" strokeWidth="2" />
        {baseEdges.map((line, i) =>
          edgeLine(points, line, '#fb7185', denseOpacity, 2.4, `dense-${i}`),
        )}
        {simplifiedEdges.map((line, i) =>
          edgeLine(points, line, '#a3e635', cleanOpacity, 5.8, `simple-${i}`),
        )}
        {points.map((point, i) => {
          const isRemoved = i >= 8 || i === 10 || i === 11;
          return (
            <circle
              key={i}
              cx={point.x}
              cy={point.y}
              r={isRemoved ? 5.8 : 8 + progress * 2}
              fill={isRemoved ? '#facc15' : i % 3 === 0 ? '#5eead4' : '#a3e635'}
              opacity={isRemoved ? 0.76 * (1 - progress) : 0.82 + progress * 0.16}
            />
          );
        })}
      </svg>
    </SceneShell>
  );
};

const MeshletScene = ({opacity}: {opacity: number}) => {
  const frame = useCurrentFrame();
  const local = frame - 240;
  const points = projectedPoints(frame, 760);

  return (
    <SceneShell
      title="meshlet clustering"
      api="@meshopt_mbt.build_meshlets"
      opacity={opacity}
    >
      <svg width="840" height="650" viewBox="-420 -325 840 650">
        <circle r="296" fill="#a3e635" opacity="0.045" />
        <circle r="236" fill="none" stroke="#a3e635" strokeOpacity="0.14" strokeWidth="2" />
        <MeshBase points={points} edges={simplifiedEdges} color="#64748b" opacity={0.22} />
        {clusters.map((cluster, i) => {
          const p = ease(local, 18 + i * 18, 44 + i * 18);
          const path = cluster.edges
            .map(([from], edgeIndex) => {
              const point = points[from];
              return `${edgeIndex === 0 ? 'M' : 'L'} ${point.x} ${point.y}`;
            })
            .join(' ');
          return (
            <g key={i} opacity={p}>
              <path d={`${path} Z`} fill={cluster.color} opacity="0.16" />
              {cluster.edges.map((line, edgeIndex) =>
                edgeLine(points, line, cluster.color, 0.72, 5.4, `cluster-${i}-${edgeIndex}`),
              )}
            </g>
          );
        })}
      </svg>
    </SceneShell>
  );
};

const InstallScene = ({opacity}: {opacity: number}) => {
  const frame = useCurrentFrame();
  const command = 'moon add Milky2018/meshopt_mbt';
  const count = Math.round(interpolate(frame, [374, 418], [0, command.length], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.bezier(0.16, 1, 0.3, 1),
  }));

  return (
    <AbsoluteFill
      style={{
        opacity,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        fontFamily: mono,
      }}
    >
      <div
        style={{
          padding: '36px 48px',
          borderRadius: 8,
          background: '#f8fafc',
          color: '#111827',
          fontSize: 64,
          fontWeight: 950,
          letterSpacing: 0,
        }}
      >
        {command.slice(0, count)}
        <span style={{color: '#65a30d'}}>{count < command.length ? '|' : ''}</span>
      </div>
    </AbsoluteFill>
  );
};

export const MeshoptimizerShowcase = () => {
  const frame = useCurrentFrame();

  return (
    <AbsoluteFill>
      <Background />
      {frame < 120 && <CacheScene opacity={fadeScene(frame, 0, 120)} />}
      {frame >= 120 && frame < 240 && (
        <SimplifyScene opacity={fadeScene(frame, 120, 240)} />
      )}
      {frame >= 240 && frame < 360 && (
        <MeshletScene opacity={fadeScene(frame, 240, 360)} />
      )}
      {frame >= 360 && <InstallScene opacity={fadeScene(frame, 360, 450)} />}
    </AbsoluteFill>
  );
};
