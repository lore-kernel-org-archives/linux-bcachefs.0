Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDF715530C
	for <linux-bcachefs@vger.kernel.org>; Sun, 23 Nov 2025 08:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763886065; cv=none; b=NwNKHEfUKkzkbVX0zAR0Y48OXwuCjb3jbVclgZ1FJH3CgDSEHXrGebtUC7m5/thrrhWkpXxuTen74hJp+PabMA1aUFhsuhLjWQ4LzsAANyyEc6d4h4ReAlB2xwh8VFOJO+K26JzD8+ziBw2mrOrNcUgf0Aoz2O1UAi39pqsu6tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763886065; c=relaxed/simple;
	bh=lP4oCQdeZ0CvndGXM+kHl8L+uOu0Mf4/zsyiTCt0NLw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=cbvx04Q0Pk7GlCacl3tDzE1Km6CaGynp6F08eUa1cU0WkJ4ocVRcItN8snc2AUj3fBSM/bEcvG3ZPVczkcA8olCHs7IWpf1Y71uG3GTNmJe+BHH7bfVGzh/cf5zRjazUZLiA8UK95avJ1ZnugqYkee9EkdGS1j3KgeXus9ILdRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-948fbd0745fso262020839f.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 23 Nov 2025 00:21:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763886063; x=1764490863;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/sAzVsQOhR4MtMeS6EbSvUvj7uLFSYdslQEFqJMXsQs=;
        b=NrS3bjdqN2MnlCEKZhI5vLllYORaPZ7mV41xm8uHmUsP/XGmezpeASNAzthvT3/d/a
         lXX1xJVNqCrakID7QOid45ktSFS1WPXYGikU6w0Vk/19nZdLJPqa3NgOFTJZ9ysynXVB
         5bATT/EqYbsfp6HCozmxmNDb5NfGm5aoB2+DiZYFR8UPCVxMdBG5uZSMqjooUUI75EaL
         SWmde2LYA/k/aZ9a+/9N2nIWCWX2qkh4sT+ONVRph6bBlZgC3ApedVm2KZ/MOSQfSUMf
         txMKKwr8MDwgVFZkhySxIwSG0wbYH0xe6rcSCpd9Fwu/sYp0RUeSHsHn8EijPCxth6xx
         YDHA==
X-Forwarded-Encrypted: i=1; AJvYcCX1bEH//lOaPR41lx4EhD7p4oiglvdQATqYhHcco1cpajNHtu9wylq++TKvHPYZN44Pf7dKHApMYXTCF20Suw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8McUA0+XffajQ6N7ZQ3Dry5vF3xqOCnQPOD63spL0C0hMgqXd
	MxIcRLky/+BAjSnXhpDUx6AEXHqQ7rORzlHtFlZo7byycayafNOz8OwdS0Ik/y7LTf7nTfHDUWv
	uPEf+pplz5s7CzhSS/uQEy7Ojp+zmx7tB1R27PSQT9OgOAHRo7cIdWqKQGvU=
X-Google-Smtp-Source: AGHT+IFVJGoQk3iK71/wIMpZDLADUHsU8/K43F3CXqi7tcroD00wQTGCctwbcdUxlE5XStfx8TSeaZyZq+a5qu0/dxN7XOVcAvik
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a5d:8585:0:b0:948:7d9c:88bf with SMTP id
 ca18e2360f4ac-949471d76e4mr522525739f.0.1763886062714; Sun, 23 Nov 2025
 00:21:02 -0800 (PST)
Date: Sun, 23 Nov 2025 00:21:02 -0800
In-Reply-To: <67306fda.050a0220.138bd5.0049.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6922c3ee.a70a0220.d98e3.0061.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in btree_write_buffer_flush_seq
From: syzbot <syzbot+cf3d1015b55ff73dcdc8@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit bcf77a05fb3d6210026483703bcacb22ed961c99
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Fri Nov 8 05:25:18 2024 +0000

    bcachefs: Fix hidden btree errors when reading roots

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17c0b97c580000
start commit:   2e1b3cc9d7f7 Merge tag 'arm-fixes-6.12-2' of git://git.ker..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=11254d3590b16717
dashboard link: https://syzkaller.appspot.com/bug?extid=cf3d1015b55ff73dcdc8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12a536a7980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1402cf40580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: bcachefs: Fix hidden btree errors when reading roots

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
