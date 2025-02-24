Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B534126F0A
	for <linux-bcachefs@vger.kernel.org>; Mon, 24 Feb 2025 19:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740424624; cv=none; b=QJ2XUeDGGiPTFucSV5CQQgHxA2iCBGdBUfezjFN7oBdVwv2wxjJ7sTW2lpubhqVLoRbsygHSlwABUTWtx1fGXs96P6TuMTXB6p27De71RaTPntKPjN3rQTuPyna5oU4NAHQeosgJCuOXm/4cPtuxrBEQFtfY5V1km28Kd7YNJCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740424624; c=relaxed/simple;
	bh=KPj1wF92A/o8Wgld2N0GchV/dCTd0ao9dHGI9f31huc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=mtQxr0FnFxYweniWrLk2rzCRs6W0+2iYehtB33snOq14oK1KJi6RUfzGRxvHdgFXgbhQIHU2gEW9lGvILg3Po9gjSP+rsJHqTgqcrToMrBmgEYB/p0njFM0MenoKocfHEcJITRUnlQfPLDgeTcYBKAQ+7Rlk8CUc1+4Ns1+lXSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-855a3423f4bso307736139f.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 24 Feb 2025 11:17:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740424621; x=1741029421;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lxz/RqCKXREOM81gm1Wu9v6BaFMeOeyBcB2VOErZh4I=;
        b=Xh+AOd/YXDJ/4ZdkvQ783Q6ktPGzFEm+fjNt/CYNxPgxfWnnUp0f29bx/nB/wqG+xD
         A9iZa11Q1dter5z0QHS41m6vQKG20CVzn0sZC5XIOiUTa8go8QDnSg+CNlDO2Bw0ZNg+
         hhjl/lPKbiB1tnXFCT6KwzkUxni7A/yuAror/UC6pEO5IsZ9mMOSJnRB2BrHSfrQmruX
         sLBv7WLi8WTMsP7uNFgq222vYiAQcH3uXLRikRRWvtQaE1jtF/ZQ4YhZtneEiUDk6SuC
         yCjwOwAGT/cqg2IgPbmZgNR+qTc/TURr7hIQ3Ro7QeIpwgqQ21i8ClYwKh4QhuTajAtG
         MvkA==
X-Forwarded-Encrypted: i=1; AJvYcCWTtQxNwtRg+PQ3tPDcnGU9GDWjrnLko5D1ppyh5qV/H0V6xaofFiNx8uEsYq0Vlqz42EjZHVphjaefHcyNnw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxXuJ41fca0gF/6gqzHmO2MOovt1UdkvTPV73MRmY7V5OJwIT29
	ST0LcVc4VZX7e4vqDN/IJ5oQJPiZiovqQ7AKM2SGXGIUVGjzt1HxiwVZUhWWSgXHcY5ufZP5WUJ
	m3VXjQjnNYYMNfQyA0MH9T4w39vvSTfQt+WHGzcVMwNZll50TXVMDmF4=
X-Google-Smtp-Source: AGHT+IH6YWr/CFsk1ozX/qp6s1Q8dCtVU8hee5T/9f05hS3RBatu6s1sYFJ0uEk8t0aynb/tUcogsde1qPaJxNxtqi5CBcaar4Dg
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c26c:0:b0:3d0:4700:db0f with SMTP id
 e9e14a558f8ab-3d2cae875cemr166784145ab.12.1740424621697; Mon, 24 Feb 2025
 11:17:01 -0800 (PST)
Date: Mon, 24 Feb 2025 11:17:01 -0800
In-Reply-To: <4659682E-734B-439A-9C3B-02257858B8F1@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67bcc5ad.050a0220.bbfd1.0092.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] possible deadlock in pcpu_alloc_noprof
From: syzbot <syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mmpgouride@gmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com
Tested-by: syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com

Tested on:

commit:         d082ecbc Linux 6.14-rc4
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=133946e4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8dcce427a3afb99b
dashboard link: https://syzkaller.appspot.com/bug?extid=fe63f377148a6371a9db
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1576adb0580000

Note: testing is done by a robot and is best-effort only.
