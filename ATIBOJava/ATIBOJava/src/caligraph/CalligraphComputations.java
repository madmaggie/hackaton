package caligraph;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.GraphicsEnvironment;
import java.awt.Stroke;
import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Locale;

import javax.imageio.ImageIO;

import com.sun.jna.Library;
import com.sun.jna.Native;
import com.sun.jna.ptr.DoubleByReference;

public class CalligraphComputations {

	/**
	 * When normalized, the height of the grid has 1 unit and the width has Symbol.DEFAULT_WIDTH/Symbol.DEFAULT_HEIGHT = 25/35 ~ 0.7 units.
	 * To draw and save a letter of this size, we consider that a unit has PIXEL_PER_UNIT pixels.
	*/
	//public final static int PIXEL_PER_UNIT = 300;
	public final static int PIXEL_PER_UNIT = 1;
	
	// Test letter(for which the computations are made)
	private Symbol symbol;
	// Model letter (to which the test letter is compared)
	ArrayList<Point> modelPointList;
	double[] thresholds;
	
	
	
	dtwDLLDistances dtwDistances;
	static String dtwlib = "dtwDistances";
	static {
		System.out.println("[CalligraphComputations] os.arch" + System.getProperty("os.arch"));
		if (System.getProperty("os.arch").indexOf("32") > -1) {
			dtwlib += "-x86_32";
		}
		else {
			if (System.getProperty("os.arch").indexOf("64") > -1) {
				dtwlib += "-x86_64";
			}
			else {
				if (System.getProperty("os.arch").indexOf("arm") > -1) {
					dtwlib += "-arm";
				}
			}
		}
		//System.loadLibrary(dtwlib);
		//System.out.println("am incarcat " + dtwlib);
	}
	
	//private native void dtwDistances(double[] letterModel, int[] sizeModel, double[] letterTest, int[] sizeTest, DoubleByReference x, DoubleByReference y, DoubleByReference u, DoubleByReference r);
	
	CharacterEvaluation charEval;
	
	public CalligraphComputations() {		
		try {
			System.out.println("[CalligraphComputations] dtwlib este: " + dtwlib);
			dtwDistances = dtwDLLDistances.DISTANCES;
		}
		catch (UnsatisfiedLinkError ule) {
			System.out.println("[CalligraphComputations] Tb sa fac .so pt arm.. can't load IA 32-bit .so on a ARM-bit platform..");
		}
	}
	
	public void save(File folder1, String filename) {
		
		System.out.println("[CalligraphComputations] " + symbol.getShapes().size() + " shapes");
		System.out.println("[CalligraphComputations] " + symbol.getPoints().size() + " points");
		
		PrintWriter pw;		
		
		//if (new File(filename).mkdir()) {
			
			/* ****************************** Save raw ***********************************/
			try {
				pw = new PrintWriter(new File(filename + ".txt"));
				int shapeno = symbol.getShapes().size();
				for (int i=0; i<shapeno; i++) {
					int pointsNo = symbol.getShape(i).getPoints().size();
					pw.println("% x_coordinate y_coordinate pressure time");
					pw.println("% shape " + i + ", " + pointsNo + " points");
					for (int j=0; j<pointsNo; j++) {
						double x = symbol.getPoint(i, j).getX();
						double y = symbol.getPoint(i, j).getY();
						pw.print(String.format(Locale.ENGLISH, "%4.3f", x) + " ");
						pw.print(String.format(Locale.ENGLISH, "%4.3f", y) + " ");
						pw.println(String.format(Locale.ENGLISH, "%4.3f", symbol.getPoint(i, j).getPressure()) + " " + symbol.getPoint(i, j).getClock());
					}
					pw.println();
				}
				pw.close();
			} catch (FileNotFoundException e) {
				e.printStackTrace();	
			}
				
			/* ***************************************************************************** 
			******************   Save image using raw coordinates    ***********************
			*******************************************************************************/
			

			double ratio = symbol.getGridWidth()/symbol.getGridHeight();

			Point xmin = minx(symbol.getPoints()); // point that has the minimal x coordinate
			Point xmax = maxx(symbol.getPoints()); // point that has the maximal x coordinate
			Point ymin = miny(symbol.getPoints()); // point that has the minimal y coordinate 
			Point ymax = maxy(symbol.getPoints()); // point that has the maximal y coordinate
			
			int width = (int)(PIXEL_PER_UNIT*(xmax.getX()+1));
			int height = (int)(PIXEL_PER_UNIT*(ymax.getY()+1));
			
			if (ymin.getY()<0)
				height-=(int)(PIXEL_PER_UNIT*ymin.getY());
			
							
			BufferedImage image3 = GraphicsEnvironment.getLocalGraphicsEnvironment().
				    getDefaultScreenDevice().getDefaultConfiguration().createCompatibleImage(width, height);
			Graphics2D g3 = (Graphics2D)image3.getGraphics();

			g3.setColor(Color.WHITE);
			g3.fillRect(0, 0, width, height);
			g3.setColor(Color.BLUE);
			
			
			/* **********************   plot letter   ****************************************/

			g3.setStroke(new BasicStroke(10));
							
			int pointsNo = symbol.getPoints().size();
			double[] x = new double[pointsNo];
			double[] y = new double[pointsNo];
			int t=0;
			for (int i=0; i<symbol.getShapes().size(); i++) {
				for (int j=0; j<symbol.getShape(i).getPoints().size(); j++) {
					x[t] = (symbol.getPoint(i, j).getX()+ratio/2)*PIXEL_PER_UNIT;
					y[t] = (symbol.getPoint(i, j).getY()+1.0/2)*PIXEL_PER_UNIT;

					if (ymin.getY()<0)
						y[t]-=(int)(PIXEL_PER_UNIT*ymin.getY());
					if (t>0) {
						//g1.drawLine((int)x[t-1], (int)y[t-1], (int)x[t], (int)y[t]);
							g3.drawLine((int)x[t-1], (int)y[t-1], (int)x[t], (int)y[t]);
						}
						t++;
					}
					t=0;
				}
 
				
				/* **************************   plot horizontal lines   ****************************/

			g3.setColor(Color.BLACK);
							
			Stroke continuousStroke = new BasicStroke(1);
			Stroke dashedStroke = new BasicStroke(1, BasicStroke.CAP_BUTT, BasicStroke.JOIN_BEVEL, 0, new float[] {10}, 0);
			
			x = new double[2];
			x[0] = (xmin.getX()-ratio)*PIXEL_PER_UNIT;
			x[1] = (xmax.getX()+ratio)*PIXEL_PER_UNIT;

			int horizontalLinesNo = (int)Math.round(ymax.getY())+1;
			for (int i=-1; i<horizontalLinesNo; i++) {
				double z = ((i+1.0/2)*PIXEL_PER_UNIT);
				
				if (ymin.getY()<0)
					z-=(int)(PIXEL_PER_UNIT*ymin.getY());
				
			    if (i%3==0) {
			    	g3.setStroke(dashedStroke);
			    	g3.drawLine((int)x[0], (int)z, (int)x[1], (int)z);
			    }
			    else {
			    	g3.setStroke(continuousStroke);
			    	g3.drawLine((int)x[0], (int)z, (int)x[1], (int)z);
			    }
			}
			

			/* ******************************   plot oblique lines  ***************************/

	    	g3.setStroke(continuousStroke);
	    	
			int obliqueLines = (int)Math.round((xmax.getX())/ratio)+1;
			for (int i=-1; i<obliqueLines; i++) {
				x = new double[2];
				y = new double[2];
				x[0] = (i+1.0/2)*ratio*PIXEL_PER_UNIT;
				x[1] = 3*PIXEL_PER_UNIT*Math.tan((90-symbol.getGridAngle())*Math.PI/180)+(i+1.0/2)*ratio*PIXEL_PER_UNIT;
				y[0] = (3+1.0/2)*PIXEL_PER_UNIT;
				y[1] = 1.0/2*PIXEL_PER_UNIT;
				if (ymin.getY()<0) {
					y[0]-=(int)(PIXEL_PER_UNIT*ymin.getY());
					y[1]-=(int)(PIXEL_PER_UNIT*ymin.getY());
				}
				g3.drawLine((int)x[0], (int)y[0], (int)x[1], (int)y[1]);
			}


		    try {
				ImageIO.write(image3, "png", new File(filename + ".png"));
			} catch (IOException e) {
				System.out.println("[CalligraphComputations] nu s-a salvat :(");
				e.printStackTrace();
			}
		//}
	}
	
		
	public interface dtwDLLDistances extends Library {		
		dtwDLLDistances DISTANCES = (dtwDLLDistances) Native.loadLibrary(CalligraphComputations.dtwlib, dtwDLLDistances.class);
		void dtwDistances(double[] letterModel, int[] sizeModel, double[] letterTest, int[] sizeTest, DoubleByReference x, DoubleByReference y, DoubleByReference u, DoubleByReference r);
    }
	
	
	public String evaluateSymbol() {
		double[] letterModel = createDoubleArrayFromPointArrayList(modelPointList);
		int[] sizeModel = {1, 6000};
		double[] letterTest;
		int[] sizeTest = {1, 6000};
		DoubleByReference answerX, answerY, answerU, answerR;
		
		String tutorAnswer = "";
		
		letterTest = new double[6000];
		int crt = 0;
		ArrayList<Point> pointList = new ArrayList<Point>();
		for (int i=0; i<symbol.getShapes().size(); i++) {
			pointList.addAll(symbol.getShape(i).getPoints());
			for (int j=0; j<symbol.getShape(i).getPoints().size(); j++) {
				double[] point = {symbol.getPoint(i, j).getX(), symbol.getPoint(i, j).getY()};
				letterTest[crt] = point[0];
				letterTest[3000+crt++] = point[1];
			}
		}
			
		answerX = new DoubleByReference();
		answerY = new DoubleByReference();
		answerU = new DoubleByReference();
		answerR = new DoubleByReference();
		try {
			dtwDistances.dtwDistances(letterModel, sizeModel, letterTest, sizeTest, answerX, answerY, answerU, answerR);
		}
		catch (UnsatisfiedLinkError ule) {
			System.out.println("[CalligraphComputations] can't load IA 32-bit .so on a ARM-bit platform => can't evaluate letter..");
		}
		catch (NullPointerException npe) {
			System.out.println("[CalligraphComputations] npe :(");
		}
		

		System.out.printf("\n[CalligraphComputations] dtw on x = %.2f dtw on y = %.2f dtw on angles = %.2f dtw on rotated letter = %.2f\n",
				answerX.getValue(), answerY.getValue(), answerU.getValue(), answerR.getValue());

		tutorAnswer += " x = " + String.format("%.2f", answerX.getValue()) +
						" y = " + String.format("%.2f", answerY.getValue()) +
						" u = " + String.format("%.2f", answerU.getValue()) +
						" r = " + String.format("%.2f", answerR.getValue());
		
		// center of mass of test letter
		Point cmt = avg(pointList);
		// center of mass of model letter
		Point cmm = avg(modelPointList);
		
		//System.out.print("\nwidth=" + symbol.getGridWidth());
		//System.out.print("height=" + symbol.getGridHeight());
		double xDisplacement = abs(cmt.getX()-cmm.getX());
		xDisplacement -= ((int)(xDisplacement/symbol.getGridWidth()))*symbol.getGridWidth();
		xDisplacement /= symbol.getGridWidth(); // normalize xDisplacement between (0,1)
		double yDisplacement = abs(cmt.getY() - cmm.getY());
		yDisplacement -= ((int)(yDisplacement/symbol.getGridHeight())) * symbol.getGridHeight();
		yDisplacement /= symbol.getGridHeight(); // normalize yDisplaement between (0,1)
		
		// width and height of test letter
		Point xmin = minx(pointList); // point that has the minimal x coordinate
		Point xmax = maxx(pointList); // point that has the maximal x coordinate
		Point ymin = miny(pointList); // point that has the minimal y coordinate 
		Point ymax = maxy(pointList); // point that has the maximal y coordinate
		
		double testHeight = ymax.getY() - ymin.getY();
		double testWidth = xmax.getX() - xmin.getX();

		// width and height of model letter
		xmin = minx(modelPointList); // point that has the minimal x coordinate
		xmax = maxx(modelPointList); // point that has the maximal x coordinate
		ymin = miny(modelPointList); // point that has the minimal y coordinate 
		ymax = maxy(modelPointList); // point that has the maximal y coordinater
					
		double modelHeight = ymax.getY() - ymin.getY();
		double modelWidth = xmax.getX() - xmin.getX();
		
		double heightDiff = abs(testHeight-modelHeight)/symbol.getGridHeight();
		double widthDiff = abs(testWidth-modelWidth)/symbol.getGridWidth();
		
		System.out.printf(" xDisp = %.2f yDisp = %.2f heightDiff = %.2f widthDiff = %.2f \n", 
				xDisplacement,yDisplacement, heightDiff, widthDiff);
		/*tutorAnswer += " xDisp = " + String.format("%.2f", xDisplacement) + 
				" yDisp = " + String.format("%.2f", yDisplacement) +
				" heightDiff = " + String.format("%.2f", heightDiff) +
				" widthDiff = " + String.format("%.2f", widthDiff) + "\n";*/
		
		charEval = new CharacterEvaluation(xDisplacement, yDisplacement, heightDiff, widthDiff, answerX.getValue(), answerY.getValue(), answerU.getValue(), answerR.getValue());
		//charEval.computeGrade();
		double total = charEval.computeGrade(thresholds);
		tutorAnswer += " total = " + String.format("%.2f", total) + "\nFINAL GRADE: " + charEval;
		
		return tutorAnswer;
	}
	
	private ArrayList<Point> loadLetter(String file) {
		ArrayList<Point> pointList = new ArrayList<Point>();
		//System.out.println(new File(file).getAbsolutePath());
		try {
			BufferedReader br = new BufferedReader(new FileReader(new File(file)));
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
	
	private double[] createDoubleArrayFromPointArrayList(ArrayList<Point> pointList) {
		double[] letter = new double[6000];
		int crt = 0;
		for (int i=0; i<pointList.size(); i++) {
			letter[crt] = pointList.get(i).getX();
			letter[3000+crt++] = pointList.get(i).getY();
		}
		return letter;
	}
	
	
	public static Point minx(ArrayList<Point> points) {
		Point xmin = new Point(points.get(0).getX(), points.get(0).getY());
		for (int i=1; i<points.size(); i++) {
			if (points.get(i).getX() < xmin.getX()) {
				xmin.setX(points.get(i).getX());
				xmin.setY(points.get(i).getY());
			}
		}
		return xmin;
	}
	
	public static Point miny(ArrayList<Point> points) {
		Point ymin = new Point(points.get(0).getX(), points.get(0).getY());
		for (int i=1; i<points.size(); i++) {
			if (points.get(i).getY() < ymin.getY()) {
				ymin.setX(points.get(i).getX());
				ymin.setY(points.get(i).getY());
			}
		}
		return ymin;
	}
	
	private Point maxx(ArrayList<Point> points) {
		Point xmax = new Point(points.get(0).getX(), points.get(0).getY());
		for (int i=1; i<points.size(); i++) {
			if (points.get(i).getX() > xmax.getX()) {
				xmax.setX(points.get(i).getX());
				xmax.setY(points.get(i).getY());
			}
		}
		return xmax;
	}
	
	private Point maxy(ArrayList<Point> points) {
		Point ymax = new Point(points.get(0).getX(), points.get(0).getY());
		for (int i=1; i<points.size(); i++) {
			if (points.get(i).getY() > ymax.getY()) {
				ymax.setX(points.get(i).getX());
				ymax.setY(points.get(i).getY());
			}
		}
		return ymax;
	}
	
	private Point avg(ArrayList<Point> points) {
		double x = 0;
		double y = 0;
		for (int i=0; i<points.size(); i++) {
			//System.out.print(points.get(i).getX() + " ");
			x += points.get(i).getX();
			y += points.get(i).getY();
		}
		return new Point(x/points.size(), y/points.size());
	}
	
	private double abs(double n) {
		return (n<0 ? n*(-1) : n);
	}

	public Symbol getSymbol() {
		return symbol;
	}

	public void setSymbol(Symbol symbol) {
		this.symbol = symbol;
	}

	public void setModelPointList(String name) {
		modelPointList = loadLetter("./LitereModel/" + name + ".txt");
	}
	
	public void setThresholds(String file) {
		System.out.println("[CalligraphComputations] file = " + file);
		thresholds = new double[2];
		try {
			BufferedReader br = new BufferedReader(new FileReader(new File(file)));
			String line;
			while ((line = br.readLine()) != null) {
				System.out.println("[CalligraphComputations] " + line);
				if (!line.isEmpty()) {
					String[] values = line.split(" ");
					thresholds[0] = Double.valueOf(values[0]);
					thresholds[1] = Double.valueOf(values[1]);
					System.out.println("[CalligraphComputations] thresholds: " + thresholds[0] + " " + thresholds[1]);
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
	}

	public CharacterEvaluation getCharEval() {
		return charEval;
	}

//	public void setCharEval(CharacterEvaluation charEval) {
//		this.charEval = charEval;
//	}
	
}
