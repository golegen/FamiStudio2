using System.Diagnostics;

namespace FamiStudio
{
    public class ImageBox : Control
    {
        private string atlasImageName;
        private Bitmap bmp;
        private BitmapAtlasRef bmpAtlas;
        private Color tint = Color.White;
        private bool scale;

        public ImageBox(string image)
        {
            height = DpiScaling.ScaleForWindow(24);
            atlasImageName = image;
        }

        public ImageBox(Bitmap b)
        {
            height = DpiScaling.ScaleForWindow(24);
            bmp = b;
        }

        public string AtlasImageName
        {
            get { return atlasImageName; }
            set { atlasImageName = value; UpdateAtlasBitmap(); MarkDirty(); }
        }

        public Bitmap Image
        {
            get { return bmp; }
            set { bmp = value; MarkDirty(); }
        }

        public Color Tint
        {
            get { return tint; }
            set { tint = value; MarkDirty(); }
        }

        public bool ScaleImage
        {
            get { return scale; }
            set { scale = value; MarkDirty(); }
        }

        private void UpdateAtlasBitmap()
        {
            if (!string.IsNullOrEmpty(atlasImageName))
            {
                bmpAtlas = Graphics.GetBitmapAtlasRef(atlasImageName);
                Debug.Assert(bmpAtlas != null);
            }
        }

        protected override void OnAddedToContainer()
        {
            UpdateAtlasBitmap();
        }

        protected override void OnRender(Graphics g)
        {
            Debug.Assert(enabled); // TODO : Add support for disabled state.

            var c = g.GetCommandList();

            if (bmp != null)
            {
                if (scale)
                {
                    c.DrawBitmapScaled(bmp, 0, 0, width, height);
                }
                else
                {
                    c.DrawBitmapCentered(bmp, 0, 0, width, height, 1, tint);
                }
            }
            else if (!string.IsNullOrEmpty(atlasImageName))
            {
                if (bmpAtlas == null)
                {
                    bmpAtlas = g.GetBitmapAtlasRef(atlasImageName);
                    Debug.Assert(bmpAtlas != null);
                }

                c.DrawBitmapAtlasCentered(bmpAtlas, 0, 0, width, height, 1, 1, tint);
            }
            else
            {
                c.FillRectangle(0, 0, width, height, Theme.BlackColor);
            }
        }
    }
}
