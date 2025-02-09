Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0021E22FC
	for <linux-bcachefs@vger.kernel.org>; Sun,  9 Feb 2025 19:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739129223; cv=none; b=mXrp1NJ360T28HNSHucYBfc/PVH2gbXoUptnqMY+x1ubdycu5JFmHjs6ZzUS8Bft0EQupTe4+ljo4NeWkkE4ntUdmdT9lTWL29GCXD/D1SKtV4WT1U/A5Oau10Y1okZkwVrrXye4UqKEwib1CYmbwVyWxXwCWWuPmUwANQ7eG9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739129223; c=relaxed/simple;
	bh=Vyd0UobHk6QyUMIqma6yCedoS8r/66Qmz3flmHKGW98=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=BHIxjUNbN4ZI/qiM43/IkeocONuELn8dE6MG2FuDleFwaes/jzkZSAxonTnUuURqt+4uqVFpyyAddkQzj1ZXArTu+VxrJ3r/vpwoO+GkK9oeSBr53daGZfqLWf+0bXQEiqyxRHOnSvf5zX6wdP/+t8kXDhX3Ch3+1F+btMueWjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3d1445827f9so13647865ab.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 09 Feb 2025 11:27:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739129221; x=1739734021;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lm3T2WLDaPlgZdqyMgzRB/LNX82XeoMBy/H3NA3BdvA=;
        b=q9RhdMo87KOEAHTmws3Yp3LYc2nbNgBuD5KYTiFFMUr39w33/TNCSDXMyuYiDaByOT
         CHAt04TmXulU/8/FAp/0e7rhdn0Ea8hdnnWn4bsIN8N3TS7vu8vSznf6zDd9LgeXv9Pa
         imjoJBAEygUQwd2s5MisB/uuaSQRRGTf8+52Go3Mr8vsXd1xHK7z4aFe7nb7y+K4vXcy
         F/W3fFkKWy3a02SN1V1OjVYA1Lrz2WWr21ziy22ldeE4YF0Nbuqmgby1kVyfkskPfYWq
         J8qra3L6G404/tTWe6Rc/HmZYb5NzkD5d2I6RYVVcYPrDCEtxGzoUujc+8fKkAoju0jv
         v/lw==
X-Forwarded-Encrypted: i=1; AJvYcCXUfPx972s7UvaUhY8LUUCw+/tXfAv184oJgbZLAc0lpRvmRoiXIT8cOUjcnO9XeQet040rlfOXAyF7QevBhw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxdWY6wL8qZ7qffHXt4oF3IifdRHEO1uCdfRyV+zzsZs6Icl1XG
	SKtLWZFA2z4mXDKcGqiKByvxJ6/J0cvV4zh5JWvs5YWJr0VDaweSodWwNLkIEvPRNfP7luqpceM
	30XWQISHTxf5DSffZGOcvte2/jt38Ner56gEwJ53dHAvPbYXoKtAQDRU=
X-Google-Smtp-Source: AGHT+IGkxGZKejY1F3ygYzzaUi1hUqpXmA/5+5Xn8TKUNvFSY0sOPF6pRt3WrIZfaS1l833h6uU3OAju00rg4KLYoZHT8rVj7Ppf
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b4d:b0:3cf:ae67:4115 with SMTP id
 e9e14a558f8ab-3d13dd2547dmr43310225ab.8.1739129221395; Sun, 09 Feb 2025
 11:27:01 -0800 (PST)
Date: Sun, 09 Feb 2025 11:27:01 -0800
In-Reply-To: <66f01abe.050a0220.3195df.009d.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67a90185.050a0220.3d72c.0040.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] WARNING in bch2_fs_release
From: syzbot <syzbot+08d08d52c3a09bfc70f7@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 8b22abb4c84058e9533d71a4814e54316ba2621f
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Oct 12 02:53:09 2024 +0000

    bcachefs: -o norecovery now bails out of recovery earlier

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=121ddb18580000
start commit:   8f6629c004b1 kbuild: Move -Wenum-enum-conversion to W=2
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=111ddb18580000
console output: https://syzkaller.appspot.com/x/log.txt?x=161ddb18580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=147b7d49d83b8036
dashboard link: https://syzkaller.appspot.com/bug?extid=08d08d52c3a09bfc70f7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1312cbdf980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=129411b0580000

Reported-by: syzbot+08d08d52c3a09bfc70f7@syzkaller.appspotmail.com
Fixes: 8b22abb4c840 ("bcachefs: -o norecovery now bails out of recovery earlier")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
