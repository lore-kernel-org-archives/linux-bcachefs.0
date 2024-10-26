Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0897ACA5A
	for <linux-bcachefs@vger.kernel.org>; Sat, 26 Oct 2024 07:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729926786; cv=none; b=I4iDYCw26exFmsY0CoFoFYmOmv0z6t3r7ynV26mLXkEPZMVdpzQPuZ4V+x8H3/rKuyC9Krps/qd9YAos24TKkRhCiDoj/1gYjoZq0r4AKVhLTb7pLKEGoUqPLXBfLKKUbqb1LSollgVTD45rXM2YZHzUWXzRunMdSUlFFA6KaYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729926786; c=relaxed/simple;
	bh=Xx/dOFi2i3DQpUhONQ6NZLtMbO64BylT5PURJHWmgGk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=kortyPUKPIq2V5OV5rukPmsZcrX/lANEHSoAON6K/hjwrFGYVP/D0qkhQBVkMHcyzKzepGwYYLDVk0nGBBXeGZUsBp5W6g594Fo2cmciCsDTDFVMg6WHmOwNbZhj6ZYyySsWGvYR45/fWEE5e36pxiybbc+C0wSAsA6gi+DIn1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a4e94ac5e9so10227345ab.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 26 Oct 2024 00:13:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729926784; x=1730531584;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0rp67qhLwfATV5QRd3EQ8f+xX7gPSztVkNegQS8yK9s=;
        b=d4AieXRg+3x1unyuW9xefiML7nabjcuPVINpA3ZJLOSm4jAtrUjn8BfMgmsaYH/klc
         FgLVtpWN9ibRI75bpfLiYur25FLr5lTTr+xk4dfCjgk6VgFqFu+Ph9WQ/0hLTT+2oDjw
         mKko5POenC69/QYAq9STxl8z2SQihND7OjFxJkTPN/2TjeQadzsRfnzPu4m6TGNNr1hE
         zJQ/ioEkEZ02ASBMypiU4/HFvOGH1Kq1lLFQM2IQVb+E4kX8Pakx8hu2A+12cX9QXQgU
         G2mqRMXucZFf+8o2okS2vJlJiRQGH5ZzrM6nHt4LQ5MOiw9I3NL8UjB5Q82GQmVSB/G/
         ZcfQ==
X-Forwarded-Encrypted: i=1; AJvYcCUN6pSlyveckgGIoSgDtdyskvQKXDqgT9zr716C23Wazl1h3DsjjV5i73epCzs4cDcR/Ae2ctIc3Ld8FRLHig==@vger.kernel.org
X-Gm-Message-State: AOJu0YyXEw36ZOGAXT01aZ8E6R3gx7njIbBDGIkECcaD2SfY5ejSYZ6o
	0jO4PUfOJpY1QUaAbHbn6wsZ+/g80IPco3kfSXcVM1AoCdv/DDah9pYP0oomr0XxRus5eyICD2d
	rvVuffk9BDLXxfXWyxDlOrMKE/6Bn2wIIcGIpfru5Ab67N+JdcKKyKzk=
X-Google-Smtp-Source: AGHT+IEwNTJMMh9GL3u+5fqFWDrHSeRggHiL5wVZQYC+bX3hzCIM1anpITxxzi11pKTVt/BttYsvYuwTcKbUU4p56PLuF976Bm/s
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1aa8:b0:3a0:a0bd:f92b with SMTP id
 e9e14a558f8ab-3a4ed2837a1mr14801475ab.10.1729926784248; Sat, 26 Oct 2024
 00:13:04 -0700 (PDT)
Date: Sat, 26 Oct 2024 00:13:04 -0700
In-Reply-To: <66f76648.050a0220.46d20.002c.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <671c9680.050a0220.2fdf0c.0224.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_fs_btree_write_buffer_exit
From: syzbot <syzbot+e4b5080f1e963225063e@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	terrelln@fb.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit bf4baaa087e2be0279991f1dbf9acaa7a4c9148c
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Oct 5 21:37:02 2024 +0000

    bcachefs: Fix lockdep splat in bch2_accounting_read

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=106e6f57980000
start commit:   c2ee9f594da8 KVM: selftests: Fix build on on non-x86 archi..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=126e6f57980000
console output: https://syzkaller.appspot.com/x/log.txt?x=146e6f57980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=309bb816d40abc28
dashboard link: https://syzkaller.appspot.com/bug?extid=e4b5080f1e963225063e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1218165f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13d0a8a7980000

Reported-by: syzbot+e4b5080f1e963225063e@syzkaller.appspotmail.com
Fixes: bf4baaa087e2 ("bcachefs: Fix lockdep splat in bch2_accounting_read")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
