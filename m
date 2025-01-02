Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EAF184E
	for <linux-bcachefs@vger.kernel.org>; Thu,  2 Jan 2025 02:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735785304; cv=none; b=sbP9tHKJhpSzc5F7JCL53AsMVMcaiDjX7yPejNaLLnLzIA2hXY80/woDiVXSP2FG3MFFo6SDi0tGAln2MU+f+kiOZ1G+vQ757m4LL4gQW+Wt99wanQSoSWbMTFuIVrgqiGe8N5+sOyGd9xUzQCFf4U81wYDJ3QM5CsECyPZXuDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735785304; c=relaxed/simple;
	bh=KrunFV0/ZRa1YS0X02lbkD6PTUWjiKTun5xuSwj25ss=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=iPJnAW+cONgZHeQukt5K0V6u3RDIgrqzf7xigowxqCIjuDJdRTUViPPzWYlJdUyAO+NqIJuSPZwadGWLVpFvT1a9A0VNKDId7q1D+KApSvsu784LNP59EMzn/xMtuHV5n08YenZcM+8z2cdzR3G32ffIn+O3ti09B+o0RhXQJOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-844e344b0b5so1016500739f.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 01 Jan 2025 18:35:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735785302; x=1736390102;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WR+/aP3OrKoBWuF6EgkPBey+X7iGWln+B+aaWV0Ut7Y=;
        b=SzXnJDwLqKWeR6TCvuMtv5ugSHLyB6Dn2PGYXjVI0pDiXsC5VPsJPCXPbSC4vQGNDY
         9qrGFZ4t+3uNpmpf0P3DQR4WXagVk1atAGAF3wPnElG2eEAOU7era4uxsMz654mUL8A7
         bUbL5vTqQpmrRIojpu6Ly0CFqc0P82E8g/EYWILk5sQX+TMNCQA+YK1BmVjo4uMUNlYl
         vNrntpkNcJcf/dYtzR28X1aromC3W/7SsFBoD35oK21YoniUjGJQS+fXww0R7ZhuFVKf
         HVwgyHyA1UWmbq+Woin/aUoH7h2Zipkk+1mBzQ0tRWk+bhVaEo/IKIRJTNju+eMIqfbr
         jegQ==
X-Forwarded-Encrypted: i=1; AJvYcCXrUb6eYJBFAMFBzgohcZWCJtTjxxZOzwDQvy4MyvZ+U+IfnZFZRTZjJcgjLxKlT52MgrjBv4dC+yfoI4qvxw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxs0nk5zcbnwI7BiM6D7/05ng9bxkjCALyJkXRmetOY7fwtlXai
	A9Rsh6NMTCyZcUnsM6k463OMEh3WSNE9lJyz29LMZDdZGFI9+ZNpzByf9982z/tMH1Jsw5qsq8K
	a3CRUm0BylY5Oebj9M8so2detrIEDoLhMGFO7GoF1V2M7rad8ivQQEo0=
X-Google-Smtp-Source: AGHT+IFlWWUkIxLGfmUV3k+e/46LlFzLCe7k9GVMr+ajievogogOZmbqaQJf6H4FCzfaIGHAKX3y/cfpMBU6yZJh5Aziq/Tmdrv+
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:b745:0:b0:3a7:dee4:c423 with SMTP id
 e9e14a558f8ab-3c2d1f7505amr264695105ab.9.1735785302535; Wed, 01 Jan 2025
 18:35:02 -0800 (PST)
Date: Wed, 01 Jan 2025 18:35:02 -0800
In-Reply-To: <6775a1a9.050a0220.3a8527.002b.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6775fb56.050a0220.3a8527.0033.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in bchfs_fallocate (2)
From: syzbot <syzbot+20254ae9982bc25a0dc7@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 1d16c605cc55ef26f0c65b362665a6c99080ccbc
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Thu Nov 9 19:22:46 2023 +0000

    bcachefs: Disk space accounting rewrite

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1750e8b0580000
start commit:   8155b4ef3466 Add linux-next specific files for 20241220
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14d0e8b0580000
console output: https://syzkaller.appspot.com/x/log.txt?x=10d0e8b0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9c90bb7161a56c88
dashboard link: https://syzkaller.appspot.com/bug?extid=20254ae9982bc25a0dc7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=170cd0b0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14e432c4580000

Reported-by: syzbot+20254ae9982bc25a0dc7@syzkaller.appspotmail.com
Fixes: 1d16c605cc55 ("bcachefs: Disk space accounting rewrite")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
