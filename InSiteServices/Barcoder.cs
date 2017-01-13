using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using ZXing;
using ZXing.Common;
using ZXing.QrCode;

namespace InsiteServices
{
    public class Barcoder
    {
        public byte[] Encode2D(string encodeValue, int maxWidth, int maxHeight, string codeFormat)
        {
            BarcodeFormat barcodeFormat;
            switch (codeFormat)
            {
                case "QR_CODE":
                    {
                        barcodeFormat = BarcodeFormat.QR_CODE;
                        break;
                    }
                case "DATA_MATRIX":
                    {
                        barcodeFormat = BarcodeFormat.DATA_MATRIX;
                        break;
                    }
                default:
                    {
                        barcodeFormat = BarcodeFormat.QR_CODE;
                        break;
                    }
            }

            QRCodeWriter writer = new QRCodeWriter();
            IDictionary<EncodeHintType, object> hints = new Dictionary<EncodeHintType, object>();
            hints.Add(EncodeHintType.MARGIN, 1);
            BitMatrix bitMatrix = writer.encode(encodeValue, barcodeFormat, maxWidth, maxHeight, hints);
            Bitmap barcodeBitmap = new BarcodeWriter().Write(bitMatrix);
            ImageConverter converter = new ImageConverter();
            byte[] imageBytes = (byte[])converter.ConvertTo(barcodeBitmap, typeof(byte[]));
            return imageBytes;
        }

        public byte[] Encode1D(string encodeValue, int maxWidth, int maxHeight, string codeFormat)
        {
            BarcodeFormat barcodeFormat;
            switch (codeFormat)
            {
                case "CODE_39":
                    {
                        barcodeFormat = BarcodeFormat.CODE_39;
                        break;
                    }
                case "CODE_128":
                    {
                        barcodeFormat = BarcodeFormat.CODE_128;
                        break;
                    }
                case "EAN_13":
                    {
                        barcodeFormat = BarcodeFormat.EAN_13;
                        break;
                    }
                default:
                    {
                        barcodeFormat = BarcodeFormat.CODE_39;
                        break;
                    }
            }

            BarcodeWriter writer = new BarcodeWriter();
            writer.Format = barcodeFormat;
            EncodingOptions options = new EncodingOptions();
            options.Width = maxWidth;
            options.Height = maxHeight;
            options.Margin = 0;
            writer.Options = options;
            BitMatrix bitMatrix = writer.Encode(encodeValue);
            Bitmap barcodeBitmap = new BarcodeWriter().Write(bitMatrix);
            ImageConverter converter = new ImageConverter();
            byte[] imageBytes = (byte[])converter.ConvertTo(barcodeBitmap, typeof(byte[]));
            return imageBytes;
        }
    }
}