provider "aws" {
  region  = "eu-central-1"
  profile = "personal"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_security_group" "web_sg" {
  name        = "nikola-web-sg"
  description = "Allow HTTP from anywhere"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "love_server" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  user_data_replace_on_change = true

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y nginx
    systemctl enable --now nginx

    cat > /usr/share/nginx/html/index.html << 'HTML'
    <!DOCTYPE html>
    <html lang="pl">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
      <meta name="apple-mobile-web-app-capable" content="yes">
      <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
      <meta name="theme-color" content="#0a0014">
      <title>Dla Nikoli</title>
      <style>
        * { margin: 0; padding: 0; box-sizing: border-box; -webkit-tap-highlight-color: transparent; }
        html, body { width: 100%; height: 100%; overflow: hidden; background: #0a0014; font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Display', sans-serif; color: white; -webkit-font-smoothing: antialiased; }
        body { padding: env(safe-area-inset-top) env(safe-area-inset-right) env(safe-area-inset-bottom) env(safe-area-inset-left); }
        .stage { position: fixed; inset: 0; background: radial-gradient(ellipse at 30% 20%, #4a1d5c 0%, transparent 50%), radial-gradient(ellipse at 70% 80%, #8b1a47 0%, transparent 50%), radial-gradient(ellipse at 50% 50%, #2d0a3d 0%, #0a0014 70%); display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center; padding: 0 32px; overflow: hidden; }
        .star { position: absolute; background: white; border-radius: 50%; animation: twinkle 3s infinite ease-in-out; }
        .heart { font-size: clamp(80px, 22vw, 140px); line-height: 1; margin-bottom: 24px; animation: heartbeat 1.4s ease-in-out infinite; filter: drop-shadow(0 0 30px rgba(255, 100, 150, 0.9)) drop-shadow(0 0 60px rgba(255, 50, 100, 0.5)); background: linear-gradient(135deg, #ff6b9d, #ff1744, #c2185b); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
        h1 { font-size: clamp(36px, 10vw, 56px); font-weight: 600; line-height: 1.15; letter-spacing: 0.5px; background: linear-gradient(135deg, #fff 0%, #ffd6e8 50%, #ffaad4 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; text-shadow: 0 0 40px rgba(255, 170, 212, 0.4); animation: glow 3s ease-in-out infinite alternate; }
        .divider { width: 60px; height: 1px; background: linear-gradient(90deg, transparent, rgba(255, 170, 212, 0.7), transparent); margin: 24px auto; }
        .quote { font-family: 'Georgia', 'Times New Roman', serif; font-style: italic; font-size: clamp(15px, 4vw, 19px); color: rgba(255, 220, 235, 0.9); line-height: 1.55; max-width: 320px; }
        .signature { margin-top: 40px; font-size: 12px; color: rgba(255, 200, 220, 0.55); letter-spacing: 3px; text-transform: uppercase; }
        @keyframes heartbeat { 0%, 100% { transform: scale(1); } 14% { transform: scale(1.18); } 28% { transform: scale(1); } 42% { transform: scale(1.18); } 70% { transform: scale(1); } }
        @keyframes twinkle { 0%, 100% { opacity: 0.2; } 50% { opacity: 1; } }
        @keyframes glow { from { text-shadow: 0 0 30px rgba(255, 170, 212, 0.4); } to { text-shadow: 0 0 50px rgba(255, 170, 212, 0.7), 0 0 80px rgba(255, 100, 150, 0.3); } }
        @keyframes float { 0%, 100% { transform: translateY(0); } 50% { transform: translateY(-12px); } }
        .stack { animation: float 6s ease-in-out infinite; }
      </style>
    </head>
    <body>
      <div class="stage">
        <div id="stars"></div>
        <div class="stack">
          <div class="heart">&#9829;</div>
          <h1>Kocham Cię,<br>Nikola</h1>
          <div class="divider"></div>
          <p class="quote">„Jesteś moim ulubionym powodem,<br>żeby wracać do domu."</p>
          <p class="signature">— Aleksander</p>
        </div>
      </div>
      <script>
        const stars = document.getElementById('stars');
        for (let i = 0; i < 60; i++) {
          const s = document.createElement('div');
          s.className = 'star';
          const size = Math.random() * 2 + 0.5;
          s.style.width = size + 'px';
          s.style.height = size + 'px';
          s.style.left = Math.random() * 100 + '%';
          s.style.top = Math.random() * 100 + '%';
          s.style.animationDelay = Math.random() * 3 + 's';
          s.style.animationDuration = (Math.random() * 3 + 2) + 's';
          s.style.boxShadow = '0 0 ' + (size * 2) + 'px white';
          stars.appendChild(s);
        }
      </script>
    </body>
    </html>
    HTML

    curl -L --output /usr/local/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
    chmod +x /usr/local/bin/cloudflared

    cat > /etc/systemd/system/cloudflared.service << 'SERVICE'
    [Unit]
    Description=Cloudflare Tunnel
    After=network.target nginx.service

    [Service]
    Type=simple
    ExecStart=/usr/local/bin/cloudflared tunnel --url http://localhost:80 --logfile /var/log/cloudflared.log
    Restart=always
    RestartSec=5
    User=root

    [Install]
    WantedBy=multi-user.target
    SERVICE

    systemctl daemon-reload
    systemctl enable --now cloudflared

    cat > /usr/local/bin/extract-url.sh << 'SCRIPT'
    #!/bin/bash
    for i in {1..60}; do
      URL=$(grep -oE 'https://[a-z0-9-]+\.trycloudflare\.com' /var/log/cloudflared.log 2>/dev/null | head -1)
      if [ -n "$URL" ]; then
        echo "$URL" > /usr/share/nginx/html/url.txt
        chmod 644 /usr/share/nginx/html/url.txt
        exit 0
      fi
      sleep 5
    done
    SCRIPT
    chmod +x /usr/local/bin/extract-url.sh

    nohup /usr/local/bin/extract-url.sh > /var/log/extract-url.log 2>&1 &
  EOF

  tags = {
    Name = "love-server-for-nikola"
  }
}

output "public_ip" {
  value = aws_instance.love_server.public_ip
}

output "url_for_nikola" {
  value = "http://${aws_instance.love_server.public_ip}/url.txt"
}