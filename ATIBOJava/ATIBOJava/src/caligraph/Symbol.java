package caligraph;

import java.awt.Color;
import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;

/**
 * Defines the set of shapes drawn on the drawing surface.
 * May contain several letters/characters which later have to be split.
 * @author Mihaela Puica
 *
 */
public class Symbol {

	public static final double DEFAULT_HEIGHT = 35;
	public static final double DEFAULT_ANGLE = 70;
	//public static final double DEFAULT_RATIO = 2; // grid height/grid width
	public static final double DEFAULT_WIDTH = 25;
	
	private ArrayList<Shape> shapes;
	private double gridHeight;
	private double gridWidth;
	private double gridAngle;
	private String comment;
	private String name;
	
	/************************************ CONSTRUCTORS **********************************/
	
	public Symbol() {
		shapes = new ArrayList<Shape>();
		gridHeight = Symbol.DEFAULT_HEIGHT;
		gridWidth = Symbol.DEFAULT_WIDTH;
		gridAngle = DEFAULT_ANGLE;
		comment = "";
	}
	
	public Symbol(ArrayList<Shape> shapes) {
		this.shapes = shapes;
	}
	
	public Symbol(double height) {
		this.gridHeight = height;
	}
	
	public Symbol(String comment) {
		this.comment = comment;
	}
	
	public Symbol(ArrayList<Shape> shapes, double gridHeight) {
		this.shapes = shapes;
		this.gridHeight = gridHeight;
	}
	
	public Symbol(ArrayList<Shape> shapes, String comment) {
		this.shapes = shapes;
		this.comment = comment;
	}
	
	public Symbol(double gridHeight, String comment) {
		this.gridHeight = gridHeight;
		this.comment = comment;
	}
	
	public Symbol(ArrayList<Shape> shapes, double gridHeight, String comment) {
		this.shapes = shapes;
		this.gridHeight = gridHeight;
		this.comment = comment;
	}

	/*********************************** GETTERS & SETTERS ***************************/
	
	public ArrayList<Shape> getShapes() {
		return shapes;
	}
	
	public Shape getShape(int i) {
		return shapes.get(i);
	}
	
	public void setShapes(ArrayList<Shape> shapes) {
		this.shapes = shapes;
	}
	
	public void setShape(int i, Shape shape) {
		this.shapes.set(i, shape);
	}
	
	public void addShape(Shape s) {
		this.shapes.add(s);
	}
	
	public ArrayList<Point> getPoints() {
		ArrayList<Point> points = new ArrayList<Point>();
		for (int i=0; i<shapes.size(); i++) {
			points.addAll(shapes.get(i).getPoints());
		}
		return points;
	}
	
	public Point getPoint(int shape, int point) {
		return shapes.get(shape).getPoint(point);
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
	
	public double getGridAngle() {
		return gridAngle;
	}

	public void setGridAngle(double gridAngle) {
		this.gridAngle = gridAngle;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}
	
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	/**
	 * Finds a point drawn on the drawing surface given its coordinates
	 * @param x - the X coordinate of the point
	 * @param y - the Y coordinate of the point
	 * @return - the Point with the x, y coordinates
	 */
	public Point findPoint(double x, double y) {
		for (int i=0; i<getPoints().size(); i++) {
			if (Math.abs(getPoints().get(i).getX()-x) < 0.2*gridWidth &&
					Math.abs(getPoints().get(i).getY()-y) < 0.2*gridHeight)
				return getPoints().get(i);
		}
		return null;
	}
	
	/**
	 * Removes the entire set of points that formed the shape containing the given point.
	 * We permit erasing, but we consider that the shape needs to be redrawn instead of just adjusted.
	 * @param p - point that defines the shape to remove (that is, the shape that contains the point is to be removed)
	 */
	public void removeShape(Point p) {
		for (int i=0; i<shapes.size(); i++) {
			for (int j=0; j<shapes.get(i).getPoints().size(); j++) {
				if (shapes.get(i).getPoint(j).equals(p)) {
					//shapes.get(i).getPoints().remove(j);
					shapes.remove(i);
					return;
				}
			}				
		}
	}

	/**
	 * Adds a Point to the Shape.
	 * @param shape - the shape where the point needs to be added
	 * @param p - the point to add
	 */
	public void addPoint(int shape, Point p) {
		shapes.get(shape).addPoint(p);
	}
	
}


/**
 * Defines a point on the drawing surface.
 * @author Mihaela Puica
 */
class Point {
	private double x, y, pressure;
	private long clock;
	private Color pointColor;
	
	public Point(double x, double y) {
		this.x = x;
		this.y = y;
	}
	
	public Point(double x, double y, long clock) {
		this.x = x;
		this.y = y;
		this.clock = clock;
	}
	
	public Point(double x, double y, double pressure, long clock) {
		this.x = x;
		this.y = y;
		this.pressure = pressure;
		this.clock = clock;
		this.pointColor = Color.BLACK;
	}
	
	public Point(double x, double y, double pressure, long clock, Color color) {
		this.x = x;
		this.y = y;
		this.pressure = pressure;
		this.clock = clock;
		this.pointColor = color;
	}
	
	public double getX() {
		return x;
	}

	public void setX(double x) {
		this.x = x;
	}

	public double getY() {
		return y;
	}

	public void setY(double y) {
		this.y = y;
	}

	public double getPressure() {
		return pressure;
	}

	public void setPressure(double pressure) {
		this.pressure = pressure;
	}

	public long getClock() {
		return clock;
	}

	public void setClock(long clock) {
		this.clock = clock;
	}
	
	public Color getPointColor() {
		return pointColor;
	}

	public void setPointColor(Color pointColor) {
		this.pointColor = pointColor;
	}

	@Override
	public String toString() {
		return "(" + x + ", " + y + ") - time: " + (clock > 0 ? DateFormat.getTimeInstance().format(new Date(clock)) : "");
	}
	
	@Override
	public boolean equals(Object obj) {
		if (obj.getClass().equals(this.getClass())) {
			return (this.x == ((Point)obj).getX() && this.y == ((Point)obj).getY());
		}
		return false;
	}
}

/**
 * Defines a set of points drawn while holding down the pen/finger/mouse button.
 *  In other words, points acquired between pen pressed and pen released.
 * @author Mihaela Puica
 */
class Shape {
	ArrayList<Point> points;
	Paper drawingArea;

	public Shape() {
		points = new ArrayList<Point>();
		drawingArea = null;
	}
	
	public Shape(Paper drawingArea) {
		points = new ArrayList<Point>();
		this.drawingArea = drawingArea;
	}
	
	public ArrayList<Point> getPoints() {
		return points;
	}
	
	public Point getPoint(int i) {
		return points.get(i);
	}

	public void setPoints(ArrayList<Point> points) {
		this.points = points;
	}
	
	public void addPoint(Point p) {
		points.add(p);
	}

	public Paper getDrawingArea() {
		return drawingArea;
	}

	public void setDrawingArea(Paper drawingArea) {
		this.drawingArea = drawingArea;
	}
	
}
