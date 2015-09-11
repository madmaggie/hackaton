package caligraph;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.GraphicsEnvironment;
import java.awt.Image;
import java.awt.Stroke;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

import javax.imageio.ImageIO;
import javax.swing.JOptionPane;
import javax.swing.JPanel;

import tutormodel.Tutor;
import jpen.PButtonEvent;
import jpen.PKind;
import jpen.PKindEvent;
import jpen.PLevel;
import jpen.PLevelEvent;
import jpen.PScrollEvent;
import jpen.event.PenAdapter;
import jpen.owner.multiAwt.AwtPenToolkit;

public class Paper extends JPanel {

	public static final double OFFSET = 10;
	
	private final BufferedImage image;
	private final Graphics2D g;
	
	private CalligraphView parentView;
	private Symbol symbol;
	private double gridHeight;
	private double gridWidth;
	private double paperHeight;
	private double paperWidth;
	private int horizontalLinesNo;
	private int verticalLinesNo;
	private int tipCaiet;
	private int penThick;
	private int crtShape;
	private int crtPoint;

	// used for drawing the letters
	// draws a line from (oldx, oldy) to (crtx, crty)
	// pen down / mouse pressed => set oldx and oldy
	// pen dragged / mouse dragged => draw line from (oldx, oldy) to (crtx, crty) and set (oldx, oldy) to (crtx, crty)
	private double oldx = -1;
	private double oldy = -1;
		
	public Paper(CalligraphView parentView, Symbol symbol, Dimension paperSize, int tipCaiet, int penThick) {
		this.parentView = parentView;
		this.symbol = symbol;
		System.out.println("[Paper] " + this.symbol);
		this.gridHeight = symbol.getGridHeight();
		this.gridWidth = symbol.getGridWidth();
		this.paperHeight = paperSize.getHeight();
		this.paperWidth = paperSize.getWidth();
		horizontalLinesNo = (int)(paperHeight/gridHeight);
		// tip 1 sau mate
		if (tipCaiet == 0 || tipCaiet == 3)
			//verticalLinesNo = (int)((symbol.getGridHeight()/symbol.getGridWidth())*paperWidth/gridHeight)
			// + (int)(gridHeight*Math.tan((90-symbol.getGridAngle())*Math.PI/180));
			verticalLinesNo = (int)(paperWidth/gridWidth)
							+ (int)(paperHeight*Math.tan((90-symbol.getGridAngle())*Math.PI/180));
		// tip 2 sau dictando
		else
			verticalLinesNo = 0;
		this.penThick = penThick;
		
		//crtShape = -1;
		crtShape = symbol.getShapes().size()-1;
		crtPoint = -1;

		image = GraphicsEnvironment.getLocalGraphicsEnvironment().
			    getDefaultScreenDevice().getDefaultConfiguration().createCompatibleImage(
			    		(int)paperWidth, (int)paperHeight);
		g = (Graphics2D)image.getGraphics();
		
		image.setAccelerationPriority(1);
		
		createImage();
		build();
		
	}
	
	public void createImage() {

		g.setColor(Color.WHITE);
		g.fillRect(0, 0, (int)paperWidth, (int)paperHeight);
		g.setColor(Color.BLACK);
		
		Stroke continuousStroke = new BasicStroke(1);
		Stroke dashedStroke = new BasicStroke(1, BasicStroke.CAP_BUTT, BasicStroke.JOIN_BEVEL, 0, new float[] {10}, 0);
		
		// draw lines
		for (int i=0; i<horizontalLinesNo; i++) {
			if (tipCaiet == 0 || tipCaiet == 1) {
				if (i%3 == 0) {
					g.setStroke(dashedStroke);
				}
				else {
					g.setStroke(continuousStroke);
				}
			}
			else
				g.setStroke(continuousStroke);
			g.drawLine(0, (int)(i*gridHeight+OFFSET), (int)paperWidth, (int)(i*gridHeight+OFFSET));
		}
		g.setStroke(continuousStroke);
		for (int i=0; i<verticalLinesNo; i++) {
			if (tipCaiet == 0)
				g.drawLine((int)(i*gridWidth+OFFSET), 0, 0,
					(int)((i*gridWidth+OFFSET)/Math.tan((90-symbol.getGridAngle())*Math.PI/180)));
			else
				if (tipCaiet == 3)
					g.drawLine((int)(i*gridWidth+OFFSET), 0, (int)(i*gridWidth+OFFSET), (int)paperHeight);
		}
		
		
	}
	
	public void drawCharacter(String filename) {
		g.setColor(Color.RED);
		Image pencilImage = null;
		try {
			pencilImage = ImageIO.read(new File("img/pencil.jpg"));
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		ArrayList<Point> points = loadLetter(filename);
		Point p1 = CalligraphComputations.minx(points); // point with x min
		Point p2 = CalligraphComputations.miny(points); // point with y min
		
		double xTranslate = gridWidth * Math.floor(p1.getX()/gridWidth);
		double yTranslate = 3*gridHeight * Math.floor(p2.getY()/(3*gridHeight));
		
		for (int i=0; i<points.size(); i++) {
			Point p = points.get(i);
			double x = p.getX() - xTranslate;
			double y = p.getY() - yTranslate;
			//System.out.println("x = " + String.format("%1.2f", x) + " y = " + String.format("%1.2f", y));
			//System.out.println("width = " + paper.getWidth() + " height = " + paper.getHeight());
			g.fillOval((int)(x-2), (int)(y-2), 4, 4);
			if (pencilImage != null)
				g.drawImage(pencilImage, (int)x, (int)y, null);
			repaint();
			try {
				Thread.sleep(1);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
		//System.out.println("width = " + paper.getWidth() + " height = " + paper.getHeight());
		//System.out.println("grid width = " + paper.getGridWidth() + " grid height = " + paper.getGridHeight());
	}
	
	private ArrayList<Point> loadLetter(String filename) {
		ArrayList<Point> pointList = new ArrayList<Point>();
		//System.out.println(new File(file).getAbsolutePath());
		try {
			BufferedReader br = new BufferedReader(new FileReader(new File(filename)));
			String line;
			while ((line = br.readLine()) != null) {
				if (!line.startsWith("%") && !line.isEmpty()) {
					String[] values = line.split(" ");
					pointList.add(new Point(Double.valueOf(values[0]), Double.valueOf(values[1])));
				}
			}
			br.close();
			
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return pointList;
	}


	private void build() {
		
		AwtPenToolkit.getPenManager().pen.levelEmulator.setPressureTriggerForLeftCursorButton(0.5f);
		
		AwtPenToolkit.addPenListener(this, new PenAdapter() {
			double previousPressure = 0;
			
			@Override
			public void penTock(long arg0) {
			}
			
			@Override
			public void penScrollEvent(PScrollEvent arg0) {
			}
			
			@Override
			public void penLevelEvent(PLevelEvent le) {
				//System.out.println("pen level event");
				PKind.Type kindType=le.pen.getKind().getType();
				double pressure = le.pen.getLevelValue(PLevel.Type.PRESSURE);	
				double x = le.pen.getLevelValue(PLevel.Type.X);
				double y = le.pen.getLevelValue(PLevel.Type.Y);
				long time = System.currentTimeMillis();
				/*System.out.println("kind: " + le.pen.getKind());
				System.out.println("type: " + kindType);
				System.out.println("x=" + x + " y=" + y + " pressure=" + pressure + "\n");*/
				
				synchronized (symbol) {
				
					crtShape = symbol.getShapes().size()-1;
				
				if (symbol != null && pressure <= 1) {
										
					// draw with STYLUS or FINGER
					//if (kind == PKind.valueOf(PKind.Type.STYLUS) || kind == PKind.valueOf(PKind.Type.CURSOR)) {
					//if (!view.getEraseButton().isSelected() && (kindType == PKind.Type.STYLUS || kindType == PKind.Type.CURSOR)) {
					if (!parentView.getEraseButton().isSelected() && kindType != PKind.Type.ERASER) {
						if (pressure > 0) {
							/*System.out.println("crtShape = " + crtShape);
							System.out.println("pressure: " + pressure );*/

							// PEN_DOWN:
							if (previousPressure == 0) {
								//System.out.println("pen down");
								System.out.println("[Paper] " + symbol + " shape " + crtShape);
								crtShape++;
								symbol.addShape(new Shape(Paper.this));
								symbol.addPoint(crtShape, new Point(x, y, pressure, time, parentView.getPenColor().getColor()));
								crtPoint++;
								oldx = x;
								oldy = y;
							}
							// PEN_DRAGGED:
							else {
								if (oldx > 0 && oldy > 0) {
									//System.out.println("pen dragged");
									symbol.addPoint(crtShape, new Point(x, y, pressure, time, parentView.getPenColor().getColor()));
									crtPoint++;
									g.setColor(parentView.getPenColor().getColor());
									g.setStroke(new BasicStroke(penThick));
									g.drawLine((int)oldx, (int)oldy, (int)x, (int)y);
									oldx = x;
									oldy = y;
								}
							}
						}
						else {
							// PEN_RELEASED: {
							if (previousPressure > 0) {
								//System.out.println("pen released");
								crtPoint = -1;
								oldx = -1;
								oldy = -1;
								pressure = 0;
								if (symbol.getPoints().size()>0) {
									long initialTime = symbol.getPoint(crtShape, 0).getClock();
									for (int i=0;i<symbol.getShape(crtShape).getPoints().size(); i++)
										symbol.getPoint(crtShape, i).setClock(symbol.getPoint(crtShape, i).getClock()-initialTime);
								}
								/*synchronized (Tutor.obj) {
									Tutor.obj.notify();								
								}*/
							}
						}
						previousPressure = pressure;
						
						if (crtShape>=0 && crtPoint>=0) {
							/*System.out.println("shape " + crtShape + ", point " + crtPoint + ": " + symbol.getPoint(crtShape, symbol.getShape(crtShape).getPoints().size()-1));
							System.out.println();*/
						}
					}
					
					// now i'm erasing
					if ((kindType == PKind.Type.ERASER) || 
							((kindType == PKind.Type.STYLUS) && parentView.getEraseButton().isSelected()) || 
							((kindType == PKind.Type.CURSOR) && parentView.getEraseButton().isSelected())) {
						if (symbol.getPoints()!=null && !symbol.getPoints().isEmpty()) {
							if (pressure > 0 && pressure <=1) {
								System.out.println("[Paper] pen down - ERASE");
								Point p=symbol.findPoint(x, y);
								System.out.println("[Paper] point to erase: " + p);
								if (p!=null) {
									symbol.removeShape(p);
									crtShape--;
									createImage();
									// draw shapes
									g.setStroke(new BasicStroke(penThick));
									for (int i=0; i<symbol.getShapes().size(); i++) {
										for (int j=0; j<symbol.getShape(i).getPoints().size()-1; j++) {
											g.setColor(symbol.getPoint(i, j).getPointColor());
											g.drawLine((int)symbol.getPoint(i, j).getX(), (int)symbol.getPoint(i, j).getY(),
														(int)symbol.getPoint(i, j+1).getX(), (int)symbol.getPoint(i, j+1).getY());
										}
									}
								}						
							}
						}
					}
					repaint();
				}
				}
			}
			
			@Override
			public void penKindEvent(PKindEvent arg0) {
				//System.out.println("pen kind event");
			}
			
			@Override
			public void penButtonEvent(PButtonEvent be) {
				//System.out.println("pen button event");
			}
		});
		
	}
	
	
	@Override
	protected synchronized void paintComponent(Graphics g) {
		Graphics2D g2d=(Graphics2D)g;
		g2d.drawImage(image, null, null);
	}

	public void reset() {
		symbol = new Symbol();
		crtShape = symbol.getShapes().size()-1;
		crtPoint = -1;
		createImage();
		repaint();
	}
	
	public BufferedImage getImage() {
		return image;
	}

	public int getPenThick() {
		return penThick;
	}

	public void setPenThick(int penThick) {
		this.penThick = penThick;
	}

	protected void clear(Graphics g) {
		super.paintComponent(g);
	}

	public Symbol getSymbol() {
		return symbol;
	}

	public void setSymbol(Symbol symbol) {
		this.symbol = symbol;
	}

	public double getGridHeight() {
		return gridHeight;
	}

	public void setGridHeight(double gridHeight) {
		this.gridHeight = gridHeight;
	}
	
	public double getGridWidth() {
		return gridWidth;
	}

	public void setGridWidth(double gridWidth) {
		this.gridWidth = gridWidth;
	}

	public double getPaperHeight() {
		return paperHeight;
	}

	public void setPaperHeight(double paperHeight) {
		this.paperHeight = paperHeight;
	}

	public double getPaperWidth() {
		return paperWidth;
	}

	public void setPaperWidth(double paperWidth) {
		this.paperWidth = paperWidth;
	}

	public int getHorizontalLinesNo() {
		return horizontalLinesNo;
	}

	public void setHorizontalLinesNo(int horizontalLinesNo) {
		this.horizontalLinesNo = horizontalLinesNo;
	}

	public int getVerticalLinesNo() {
		return verticalLinesNo;
	}

	public void setVerticalLinesNo(int verticalLinesNo) {
		this.verticalLinesNo = verticalLinesNo;
	}

	public int getTipCaiet() {
		return tipCaiet;
	}

	public void setTipCaiet(int tipCaiet) {
		this.tipCaiet = tipCaiet;
	}

	public int getCrtShape() {
		return crtShape;
	}

	public void setCrtShape(int crtShape) {
		this.crtShape = crtShape;
	}

	public int getCrtPoint() {
		return crtPoint;
	}

	public void setCrtPoint(int crtPoint) {
		this.crtPoint = crtPoint;
	}
		
}
