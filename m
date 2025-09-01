Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D68341651
	for <linux-bcachefs@vger.kernel.org>; Mon,  1 Sep 2025 14:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756736888; cv=none; b=Wnm4MbTXy1SzpW70cxZj91hh2IiCgj0uqV1kYSPDcE+EekChEYr0SSjpRInluP8MOfF9+B/4Rbg2XTJaB1aKWr7xU7f2cHDhZnzcQgOLlMt3hkm843WGmb0eW1PdZyU3TgkNAQCKw37KTTFU63crKe6pjBQ6DPlrc4OOW4habjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756736888; c=relaxed/simple;
	bh=SswYK8NK8/NBuIlxZPEINe8a01YkBoblyh0FZHT5vFU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=s8js7fyQhSS5YK83u+O6YSQmTaqjZUZgyNBtezZP7jbfQAnaM6M47Up0X2hjU3F3NWeUVBuTAgIIW/TOzfFOWsJmE6I8mVsyeVohJEPswbxfVlTeQPTMaTDyQBY+4o2BmHRALPZe9Fs7d5zE8Gv7v257zXJd9mUHturMsYAXMSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3f321907716so39174265ab.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 01 Sep 2025 07:28:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756736886; x=1757341686;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KzoS/rFpWfbjyEKOrpfdLItOmctXoSuOQ4sdGnPwuk8=;
        b=XeyoS2vUrRUrE20GxpBDaMRW2YLmprEahBxFNMC54EUs+XBi9YBw6gJz9U6ggzoZTM
         vNGVI1TlRMlIAGjQXPw8bzmtARZ9oLIuqbeMLJl9BvD9N9Sz5eD4C3/1P2Di53mj6Be6
         rzXG+5cXis6cD604aY0KafJ27WMUmZR+3ytKokQXkCN/WeafRIMgku5I2OENPn6ITcfJ
         99lGuqqlhm9rBojEZ5wbmHoCYHG4UEqLWxAhLOA+5ybUYkbtHTG/qaFHScwzHWdyXAft
         0jdpOYzEBLZ8Pcvb+Glkm144KtsVdMHBS6s+5KtiRuiuaH/8HuYhoeG/EIzmvoiEUgM4
         M2Qw==
X-Forwarded-Encrypted: i=1; AJvYcCXTIb8vzqZZYlViHCXcpwn5xx0ABqCtAYPQeJHAYvx0Z7F5j1TEEYPfyAZeA8qlweVJKTEjw1dgdoF20OR1iQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzU47icP3zNfDhnMvYw/ht/a64xzPk58O5vCFt4+CWBUDnydLdf
	1cr7+7nOaOmJvBATGpMyMWoEiCwWkamtXl3Js+iRjtR1J6JJRs2rIOhsuPUCcKRi30Ilx6HgvXe
	Y9VCSCsDkBWXf3KMQzWmdqBmh1wNwrzFCurYbZxvuV16WJjLvxIDA14rraEI=
X-Google-Smtp-Source: AGHT+IEiesIfDRZe1XchjiZ7FWywLU9bIPuEeclcfhByJXEa2ihgbeBdxEOAoCYTZVWipvfw4VMuDkEPiCeKFq7XWlsmXrNjYa8Q
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:144c:b0:3f3:cd20:d7e4 with SMTP id
 e9e14a558f8ab-3f3ffda2be4mr162622435ab.1.1756736886309; Mon, 01 Sep 2025
 07:28:06 -0700 (PDT)
Date: Mon, 01 Sep 2025 07:28:06 -0700
In-Reply-To: <68721d9e.a00a0220.26a83e.0074.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b5ad76.050a0220.3db4df.01c1.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in __bch2_trans_commit (3)
From: syzbot <syzbot+b6ef9edaba01d5b4e43f@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit d0855e210675b8018f4e89ca77cbfa133bce3a71
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Thu Dec 12 09:03:32 2024 +0000

    bcachefs: Kill snapshot_t->equiv

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14f2e242580000
start commit:   c330cb607721 Merge tag 'i2c-for-6.17-rc3' of git://git.ker..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16f2e242580000
console output: https://syzkaller.appspot.com/x/log.txt?x=12f2e242580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e1e1566c7726877e
dashboard link: https://syzkaller.appspot.com/bug?extid=b6ef9edaba01d5b4e43f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=163eac42580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=136c1862580000

Reported-by: syzbot+b6ef9edaba01d5b4e43f@syzkaller.appspotmail.com
Fixes: d0855e210675 ("bcachefs: Kill snapshot_t->equiv")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
