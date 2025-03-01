Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10124D2FB
	for <linux-bcachefs@vger.kernel.org>; Sat,  1 Mar 2025 00:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740788524; cv=none; b=Bd+N7JMq5kDUrSp3AeYQHF0Nmvw7D8SDg+WoAlHYLcZU8hgOwJAZ81w8WYQFdMUYHx0N45oH/rzOsJinTJYDiXIs8wnpEaECNzB5+L3YXLxaV8UKyZ5kszwGh8Y5QzdW7oloV0LyXvJHn4dTwPgJm3DzZfz8x1qVjBG3UaZXTGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740788524; c=relaxed/simple;
	bh=d23CwhsVnNOdGWq6rbWCMbTUmxYX49JZJarGho1lNME=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=k8GX8222cALbb5IcDBGpX5kOSQ6yWyoGfS2i/YnMLpc/AO9jk9xyJcabfEp8p7dJg2Grx4vJN3qSafJeu6bT7msLt8JOtSjvcCXqsXv95aA54KBqipsXZ/hk95FaDqHU4iZi8OrWRuT1aZEnI2c4THcmiN6ZmlRQ4xrxe6Xb5Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3d289bf6c39so34291335ab.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 28 Feb 2025 16:22:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740788522; x=1741393322;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SnjErBV+M0/5ybVsx6d7eAIoc/JglLB98P2e5faRA7E=;
        b=GpsudNE12EJCru9f1j7fx7ovFVEqh+981UG8gIZVHd0W1U1vQl8FsBsv5RvfEgHf9D
         b62PTjbXiIcB9V1iOG7tetpknzSHqdtW9pGsDQ9pRQZV1IMhxi/EO7YdFUZmE0t46AlS
         aScheMNYfV8pl5rccW8r9xXsMuI5FMqAyI1IQv6dlk+99Ej15VbQGB0u43sKRlrXEbSZ
         UHMhnv/KU5Egswu5TWWMkNTYC8ZCXxlGjq2GQKzqqwbo+v3PG4NVWEj9XBqTWug92hWG
         jqoCDav5z1/Cs8GAYKKjAR0PvN6s/e3azqc5Nbda4piQxFvv+C4AMI4mKpPyStNM1Y7l
         GV8A==
X-Forwarded-Encrypted: i=1; AJvYcCWtn6DtNiwxBZFpiZqV5tifOE4YDg17pRaCCAp9ke2Ta8jUc2M7lgk6Kkdus4bHUpLk3AW++fBcaj1al2/PYA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwDJBJ7w48QbihZMXQQqo8Tv5dLIcHAj0YS0dVSBy6E+GEUPGwt
	3RnxhRoqrMHtMJZGMw90VJaUjP9ZGoBNGhhfY307albleDbmVffQR80DRvYyCNhjTlDkOEZdQzb
	+kwgp4ZDJ2qyNp8eG1n0GSvCCmrf6o7Q3xe9az4I6AgrgHLnQedxCdgI=
X-Google-Smtp-Source: AGHT+IFK/+Voer3eS9nJJ3bYQfdwYAE5ugYuJdGLAyLLQCY/ACDcPRlCyhOrxJ0CnyTRZ+tpJBVu0AIj8ZAgaveZ2D5+L68bWSvD
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:194b:b0:3d0:26a5:b2c with SMTP id
 e9e14a558f8ab-3d3e6bc6b2emr43948505ab.8.1740788522212; Fri, 28 Feb 2025
 16:22:02 -0800 (PST)
Date: Fri, 28 Feb 2025 16:22:02 -0800
In-Reply-To: <67c16ce2.050a0220.1baf.000e.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67c2532a.050a0220.dc10f.0154.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in invalidate_inode_pages2_range
 (3)
From: syzbot <syzbot+de1434c5355cc909b734@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 1d16c605cc55ef26f0c65b362665a6c99080ccbc
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Thu Nov 9 19:22:46 2023 +0000

    bcachefs: Disk space accounting rewrite

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=116557b8580000
start commit:   1e15510b71c9 Merge tag 'net-6.14-rc5' of git://git.kernel...
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=136557b8580000
console output: https://syzkaller.appspot.com/x/log.txt?x=156557b8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8de9cc84d5960254
dashboard link: https://syzkaller.appspot.com/bug?extid=de1434c5355cc909b734
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11d297b8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=119af064580000

Reported-by: syzbot+de1434c5355cc909b734@syzkaller.appspotmail.com
Fixes: 1d16c605cc55 ("bcachefs: Disk space accounting rewrite")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
