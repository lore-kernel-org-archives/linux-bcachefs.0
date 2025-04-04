Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D1B208978
	for <linux-bcachefs@vger.kernel.org>; Fri,  4 Apr 2025 16:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743784865; cv=none; b=mVF8XHap/XUYsWttTy9BQVFXLy2NWNCWzRSUcT7zv18hTrrTJ+wzNQPGxof7qqZkEP+3J4gqjN07pIGzsy1s4h/VW7f7d937C1scDA9FBnQITsvVE0TjLnto7jzcSuOeHwLPwCogM28OzmzfzxkmCxreivfEW5HJZXZz4jpLvfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743784865; c=relaxed/simple;
	bh=VxOnCF+HvtBQ1CZSxMxHGlCSfaf9QunSsEFcUcUV5nQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=nryacoRVFMxbK4NQJuXgUSHOrUmQ0Y4IWK1Yzdy74gEPwW41GSqI5Vjvp9tD5VSKFbaGCqyglXifVTi1QSzSUcago/vu/g/rjRuSptoJIxuo/h3dyyXoMYNv5EJsR+sAWZLMPWVGeTBmxAOV/RyyncfHKEwX9AX08XgvzAkrmAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-85e7f5129d5so205599739f.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 04 Apr 2025 09:41:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743784862; x=1744389662;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=do8v4tJlaxjSQbHtK73xnzF5iTyzFImZXeIUVjiHgzM=;
        b=MxF9OT7lyFMqWCIoBYc9EM7SsHxIII+ITdYxDOHOCmyR0M6LpTgv0X6nvX/bVA4OE5
         IrYrUO+zC+Ysb9J6MPt/i4iym6UmO0W3PsfkDmcO8MYXDGSWHEWFvdEQue18T4cQc4mg
         GWWN8PiJpCdwRSddvxdukMo3F8hdjR/u+ulQgGwqDKvukWnG4z+coWHYOjUp4s7MDkb5
         ITs0398ECv+QGRzMk2Lp0vRifNO2ia0C8xvSL/yaz32+g54yw9hhTEh2TDUy1nT2lDna
         IjYpkpANHGIVYjDpaAiRas443Qtbm3qrDuCDGVxBepZa63uM6pxHQsWHTk9nF19vew1q
         0RIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVMhQ6yj74Ezs0FZdjyUBSTyY+vEzhlsz32mO+SMwNbZ2HGDdQx96j1Z7p22j8DNwl9xwuBQ1UwNNjWmWgCOw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyEEa18t2hca0R+MbyUXuiXQ1urp44I8iF6eXnyR96gOj8rF9hR
	eD3tolYwKdR7Em/yFZIr0AjIkmfIyndm6NJbh27QorjvknhHFQcI5RUEegl2Vtf3MxeGaSGzEnW
	26AK6XXQ2u04MOLnP6zuVhnOMc8oWUjqXkWMukqZmyvUN8IgOEsoXzuQ=
X-Google-Smtp-Source: AGHT+IE1oPxntuLvDh8XS6TdZRzprpiGADEz1QwT8rwhimBxdxZ0/kfSsWkevNYlD8H4jzF6o+RKeyN3EdBo/jXfnHU3vQmRIEFx
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1808:b0:3d4:337f:121c with SMTP id
 e9e14a558f8ab-3d6e3f0533fmr39029825ab.10.1743784862688; Fri, 04 Apr 2025
 09:41:02 -0700 (PDT)
Date: Fri, 04 Apr 2025 09:41:02 -0700
In-Reply-To: <67eef48d.050a0220.9040b.0262.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67f00b9e.050a0220.2dd465.0219.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] general protection fault in bch2_snapshot_tree_oldest_subvol
From: syzbot <syzbot+baee8591f336cab0958b@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 45f0e6c838e5d9af3f013adb4ba9aad3bcbcbe3b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Fri Feb 7 06:33:01 2025 +0000

    bcachefs: bch2_indirect_extent_missing_error() prints path, not just inode number

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10dea7cf980000
start commit:   a2cc6ff5ec8f Merge tag 'firewire-updates-6.15' of git://gi..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12dea7cf980000
console output: https://syzkaller.appspot.com/x/log.txt?x=14dea7cf980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=941480366fefa055
dashboard link: https://syzkaller.appspot.com/bug?extid=baee8591f336cab0958b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17062fb0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=131a0fb0580000

Reported-by: syzbot+baee8591f336cab0958b@syzkaller.appspotmail.com
Fixes: 45f0e6c838e5 ("bcachefs: bch2_indirect_extent_missing_error() prints path, not just inode number")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
