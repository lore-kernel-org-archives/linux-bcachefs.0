Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DBE28B4EB
	for <linux-bcachefs@vger.kernel.org>; Mon,  4 Aug 2025 19:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754335806; cv=none; b=bVodLI3DSj1R6erHcC2y/r3t05FvS7fnwCJqPN8I8BopENOWG9IxHRrUIqYPU355qYm+AaoQAMv6/OgAitpjQE87M6I4xejQRcY4noIo/TjskimVJklBeb0Cmzc4zDuU0h1ermwh2hfw1PjlFHFzJb5YP4H2WgOEQeaj/92htk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754335806; c=relaxed/simple;
	bh=fOmWH6T2Ow8xnKuhdw4jCSegzyrjcNefsp4HQR+Ot/4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=GiyQy1O1pN+4W4BsFE9DY40fjtGs+57RM/VDmB2HVGFryskoTOSyXdfS7HdYVBsYuUJXb+MtoHiQQZp+TCJ8SY4mt2bwClXmFWTek6aqmWnptvU2OUEzM7NvsUPmJVpUIKIXi6FLc3R/mJpEfSj6a3kOZlhp8S9X2zJof+8j35o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-86a5def8869so1067549339f.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 04 Aug 2025 12:30:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754335803; x=1754940603;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DmHoKehu4O4jWApi0R1qiL4KWmJQ2TRS/lb9a0gB/cQ=;
        b=OH3b/XOVhru83LVlTuTe1eGOIzvHREf6BP4Ua1ylg9zoweO/0GNgUycLXpYkbvc+XY
         6c1xAYJ9riccGEbrlURaf6dSAQ/4QyyBwORHWDiPL8Qh+NYRg1n1Yqa8L4+cg5XTL25K
         zbcpFHnqUxKgSrZUNrXi/3mUdzqUwCCry+YzKLm0O2X8xomTaN9BWirKPC+GP9izaad9
         ROUVt35kn4r1ylIEicoORPiZOGumNT0H/A8EdSWh5hWnOedl5fUssuLssBNnY2r4L4nr
         55aH7sAedZ1gQInMMusHqDRVf6yLVCjkJA6DoWWm6uvDwBdA4f5Z3n3iRMOUkncq0yz2
         9cOg==
X-Forwarded-Encrypted: i=1; AJvYcCXcdZmZMW0PwmtSMlFie6OgBnl69SjgRASABodqE7fdsrQT1OsWT4s5bDDdk9s/C9JqoQHawleT4dYcyHqsSA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyn0EZfoIp0gBul82zzXP5ZgZF23uq3bQxNRf8sxLEzSwiZ6jRn
	umvA7nbDgUaarM4ie9At+vOX7ytqNOOAW3AxBFKd8Mkaog3tYUifD250/YotLf8Tl9yktRWMaLC
	0Dur3SnSZJqkTeygJfRwbENvMKEoH2/DDd6l61b6e5TgrN4q1GX+G4rgxuy4=
X-Google-Smtp-Source: AGHT+IGbYggjUtG1oqcPNs8Dk/McEy/ytGOSxsiwmA/eJL8RhSvrAHgoiKBaOcZDS4Se3Vhq7UHJXeNrp3EegbiaU+JsxuFtStzk
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a5d:9b89:0:b0:864:a228:92b4 with SMTP id
 ca18e2360f4ac-8816834e0d4mr1558256939f.7.1754335803785; Mon, 04 Aug 2025
 12:30:03 -0700 (PDT)
Date: Mon, 04 Aug 2025 12:30:03 -0700
In-Reply-To: <2D7EE43B-5C6F-4F46-AE09-D5B50FF64589@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68910a3b.050a0220.7f033.0011.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] UBSAN: array-index-out-of-bounds in bch2_accounting_validate
From: syzbot <syzbot+cd063f869beedf5b9cd7@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mmpgouride@gmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

failed to apply patch:
checking file fs/bcachefs/disk_accounting.c
checking file fs/bcachefs/sb-errors_format.h
Hunk #1 succeeded at 323 (offset -5 lines).
Hunk #2 FAILED at 337.
1 out of 2 hunks FAILED



Tested on:

commit:         35a813e0 Merge tag 'printk-for-6.17' of git://git.kern..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=cae1291240e8962a
dashboard link: https://syzkaller.appspot.com/bug?extid=cd063f869beedf5b9cd7
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=135082f0580000

