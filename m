Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C38B61FCE
	for <linux-bcachefs@vger.kernel.org>; Fri, 27 Sep 2024 03:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727406907; cv=none; b=ECRwZ0btrfdeO1lxQ1aMsWkwc7Sa0iuM/VmzSrPccPzGKKE7I72Oi+v5moGmwg0z7vUY6eSg81Zuq+5LihIeJJ4PFWrFbmt8SLYmdrjGbRZLmejBeUwnZl/Ctb+PPRq8vFbch5eeUe2LvL36yx2Y6eoQ5C+SBfIwMbMyYTBdmTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727406907; c=relaxed/simple;
	bh=IfVUnQzvsU3erRjtyBu275kBik322qL9HgyBtPj5+e0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=iLDq/3H6RQSUXJ2i99dD9KuQ/7AztvPy0xv1qPQFnpLGmZWETPe5XRlYKkkZhApQTw5W+UH3NwTHSrOkyCK4+D6WFLUy67O+Yg4NFwb9x43SUlx6zj/2SdKd2FVx8047mObTy5azRHLlLBDhSj0yt53xK89ZDK7qct30RmCdxdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a0cadb1536so18347455ab.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 26 Sep 2024 20:15:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727406905; x=1728011705;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vtM/9D39coALiNrlEfJyi9fXiC+6RfG7FZwDHO74uRk=;
        b=gDk2dv6D698jcrWe8xoYE4ta4puMGVvLK/45uDvZw/CYIiOBJ90gkly0QfaOYP748F
         9FBW33mmkIUASXh6axFT4TnLDzXwBSMw1ajiJxtYrO4rit8V9TsaQu61Zt0MV5oEHYMQ
         Z9S6kBEDvNr8fe/3MpWyS0kpY+ghDo0SlmwAnrQPtzCg4xckUVynBrAFZzEmi89H3+++
         WvLUtCR2R7JTJIJPDoamxTje3llRrVMYj8IHbcf/vhzzNA+SLZWEEtDEKzAfUZ36aLbv
         n8T8xlwODqraWvqo41ATIklPxtuLAK8q96lQYNHDKXTpDDuxeQMtrC5FfL6fvMVPYgRl
         AWLg==
X-Forwarded-Encrypted: i=1; AJvYcCW1spU9jkL+pq+nN8mm/i3zUaGiu5ETw/Pmm0j2YHkuTzajx0rztLt2ODOtrS9eg21XwBBHHGCvvzllKV4SRA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx37rgrOdDtIfQR1jynw2iHqILNuaJWMWq8XhbAxu78QVrhwBXE
	5Eg+CBeSJGuHDn6Kinc3y22Vq2kdwVASn5dHaY0C5+Efj/yOxatKjwLurOPZE5AQ4uOO1YZsBaG
	kbdFZmX3RAqF1xbVsvtP3NFVakkErrgf55cwW+2gWvDExOS9/34JwI3U=
X-Google-Smtp-Source: AGHT+IEGTqjsQ/oJn0hD8jsSMGmR0OsAiQuVDLHvFz7nHX7qFlEYhJSBTm3BXyVIJl2UHJPPKpQQN5NyVhSvM9iZaIEwTd+rMxZl
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1582:b0:39f:5521:2cd4 with SMTP id
 e9e14a558f8ab-3a3452bf444mr15452985ab.26.1727406904713; Thu, 26 Sep 2024
 20:15:04 -0700 (PDT)
Date: Thu, 26 Sep 2024 20:15:04 -0700
In-Reply-To: <c3d3c52e-ec5b-4238-aac7-284a3838be90@126.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66f62338.050a0220.46d20.0009.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in bch2_stripe_to_text
From: syzbot <syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	zhaomzhao@126.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com
Tested-by: syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com

Tested on:

commit:         1ec6d097 Merge tag 's390-6.12-1' of git://git.kernel.o..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=13ffe59f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6265dd30e362bb47
dashboard link: https://syzkaller.appspot.com/bug?extid=f8c98a50c323635be65d
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=151daaa9980000

Note: testing is done by a robot and is best-effort only.
