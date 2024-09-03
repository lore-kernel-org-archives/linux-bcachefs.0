Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D8524211
	for <linux-bcachefs@vger.kernel.org>; Tue,  3 Sep 2024 02:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725330848; cv=none; b=eSrcn4dt8fOCr93ANtPj9r/voPy2S/f6glXC0B/ROHZ9zxV/HkfhzNB/XC0ZQk6T5/5VDV/bGzQVjhejGqsCmC2lWCr15jKsifa9q1i9SOjNWy6Qkb0oK9AZTF/btaMb0kJRpEGGwZ9MBcKX1DbqI35ot8n0pPq3/AGwiIp5Qms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725330848; c=relaxed/simple;
	bh=UOHCw+cF8tvj2KpTUAWgY9p9yXNgf8o6wkUC9wx1Xk4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=bF+ToV3zO4J2IZun2LFcax92qAFBxcxEWOP5sQeCWPBeoFZ7oQY2SGOpdPJ2r0q+meLb6aC55qa50BtD63ROAzWzR3crlAK0y1LWnB6Tc8pWXFElJYTjOW3htjIdVND6gLW50EZ1yLIs9nh8WiniaN63mi4SCOEjUKGLJafQf6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-82a22983440so460621939f.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 02 Sep 2024 19:34:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725330845; x=1725935645;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v4drJsG4cIDr3I5NkQbnYT/k0mpZe+PZ2n49CNlnX0w=;
        b=Y5qihezLuDeGmA5bJUagNJW79NxI9aW7iekIbwtpAQA6aZsmdGT99lF3EqpZRgxWBv
         cvcBDZgozJHudIpuvdCP45aduBpo3q4tp/9bzOXee7M9aQXxoW+H99bVATpxA5dzt24+
         0ufM7hqLJPLeur6eg30ZnA7dAe+t0qWDEin9yLkszG3GKB66wLzO2PZX0k1hCtTgYF/Z
         CuV6miD6LFHAG1J4/Nt/NtCJ7Z9xWEHy0RybXF0yTdFIqgUGNoTYH3hZP58aW/fXmDPD
         pKhXGZG7fUXMTtEGDbXF6eyLquFSAJ5jBxk/iLIeRWeJQRNfuA1+7+T4TXkN7FIhZ7Tm
         Z5Lg==
X-Forwarded-Encrypted: i=1; AJvYcCVc3gLw/1/vchL/nOCHRHK4wznRZ7QINhFlZk7J4Ze5E0kz7B77Y30Kbo/gKd9UzL09w9hkRGDFYTWOAsPE1g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwTf6NN3ZJD7xJ82ceW5wax+EERA3c2y87b8XNbOc//Ob9ug8F3
	j6Z+QXgNQTd8aJUuBINpF8RMsQS2sAAOgu/oK3EXx3bgeceJrYzLeD92EXrbycwx/u0dD2cua7z
	iAY8i4yp+idefmcCgn3VRp53icivrqXHYxtXG6sod2ioKr0d1lYVW3zk=
X-Google-Smtp-Source: AGHT+IF6HRzmy3uAMKL6AxsBzVXEuNxaW8HWHTEdIl0EaLq704Fu+i3tq1TMG6e307FJmdpipFE/HFCiLkBYLYV5Y5unhue/5r53
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:4be8:b0:4d0:51aa:f250 with SMTP id
 8926c6da1cb9f-4d051ab4928mr14181173.3.1725330844993; Mon, 02 Sep 2024
 19:34:04 -0700 (PDT)
Date: Mon, 02 Sep 2024 19:34:04 -0700
In-Reply-To: <tencent_6ECC3C5D37B696EC36DE4A4C759B770B6709@qq.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000022db4706212de4ac@google.com>
Subject: Re: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in member_to_text
From: syzbot <syzbot+064ce437a1ad63d3f6ef@syzkaller.appspotmail.com>
To: eadavis@qq.com, kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+064ce437a1ad63d3f6ef@syzkaller.appspotmail.com
Tested-by: syzbot+064ce437a1ad63d3f6ef@syzkaller.appspotmail.com

Tested on:

commit:         67784a74 Merge tag 'ata-6.11-rc7' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=135f0f33980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=660f6eb11f9c7dc5
dashboard link: https://syzkaller.appspot.com/bug?extid=064ce437a1ad63d3f6ef
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=140dcb1f980000

Note: testing is done by a robot and is best-effort only.
