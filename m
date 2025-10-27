Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F251E34CDD
	for <linux-bcachefs@vger.kernel.org>; Mon, 27 Oct 2025 12:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761567604; cv=none; b=mqjCmpezRjwlpa5MXX5LvKL0G2ihJ31CrUuhGevVMqZD0JjaYxlD+x0kOtM0mRpmE5nEdzyTIvR1wFIlVexeGGUQaIV0nv7bUgFCRrGnt1B9TSaX/Fxh4raIx95ihCLsa2rr0mQNEaZ0KTPOCZ+nuu58U0jPc+gIYClw91GsHdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761567604; c=relaxed/simple;
	bh=+v7ks9/eTNNhXqjj83VGdNIZhAXyFvyg3wHQrgrPCtQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Rt1ymEjMzbePsvsBgMTYLdLW68r+b931xQu3OpCq42ROGfYdHA6FyEO0Wme957f3wuqp+3vz2wOjze3fDRu1Nz32A9EHr8hCkbYgCadjW9MlDZW16ps0TI7nnNfAN3AygFB8qM6kdzNArc2EXHK4hEkl6jHHS94lkcmm3sKluzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-430c477fe44so52311405ab.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 27 Oct 2025 05:20:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761567602; x=1762172402;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qkdLZi4ZV+215bJaTi/JeEB1alaBWY0kyjpkyUYTr3k=;
        b=fEdwvjq2/0HpIIdHevK9UR3S3jJ+nRLG7HdFKR0SE8Y2cwwJTuIGEOSCk2fJunPSC6
         T5aFrfOgFqpXHs+n1vlSyUqvx5igPrU0rPr5fXW345ClM6ieD/EMecQfR+SxeZ6PIJu7
         IyezOIR1uo5UQJvubl9EZ/6vX7XkGw1gsYGYPsRMbr0pVqDlVLYRS6dKAxSsiRZi2+qV
         YeyXuiN0rC6Ycj9o/fLTt0QJpn3YPl0cKx9qEte1qX5aXI2PFiKcPYXkHDmx4+WOxwzG
         rdKIZ7gPGBZPeCOPvxfE2nBMOs4oGCuPhJeMX5A29cmIZK59RGMavBShzUCSS9tVT6v2
         szTg==
X-Forwarded-Encrypted: i=1; AJvYcCV8PoR9St/WwJBUpWr4F+nqnp/Ptm3BcsgGdAjTaAri7evG3JzR5wBRKvW7+ycTviRN6m61+z5ixUyzYyPGXg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyJJNyuxkF+0MhmWtejMcMtHHCE7ujp2v+O1cIy29Lhnnsjda+A
	g0kZfr70KG49aAeTo9sHczx9hvbiKpXFpvBqQt/0WX499ydbyXDn23Ga47dro9jbO3LfzxeX2A1
	u1KzyMqgEbFJqj2K+vI1KMhu2bLGNyZp4XPv4lRVhDQ6gxiJ4P7IbE+dw0Ic=
X-Google-Smtp-Source: AGHT+IHfAtKzApOq/yF+X5k8SHk/HjFQMhS741f1oSYAqo7YLgpQGhwkBXZCLE4F7N/1tfWLOg4KPNfxoTqWPW6jXC0CoLi13FsC
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3c04:b0:430:b27a:7702 with SMTP id
 e9e14a558f8ab-430c5204155mr511415395ab.3.1761567602122; Mon, 27 Oct 2025
 05:20:02 -0700 (PDT)
Date: Mon, 27 Oct 2025 05:20:02 -0700
In-Reply-To: <68bacb00.050a0220.192772.018c.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ff6372.050a0220.3344a1.038f.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: use-after-free Read in bch2_prt_printf
From: syzbot <syzbot+7f176adb30b21606c5fc@syzkaller.appspotmail.com>
To: david.hunter.linux@gmail.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, 
	linux-kernel-mentees@lists.linuxfoundation.org, linux-kernel@vger.kernel.org, 
	nirbhay.lkd@gmail.com, skhan@linuxfoundation.org, 
	syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit f2c61db29f277b9c80de92102fc532cc247495cd
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Sep 29 20:43:52 2025 +0000

    Remove bcachefs core code

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1190ef34580000
start commit:   d69eb204c255 Merge tag 'net-6.17-rc5' of git://git.kernel...
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=bd9738e00c1bbfb4
dashboard link: https://syzkaller.appspot.com/bug?extid=7f176adb30b21606c5fc
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17f99312580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: Remove bcachefs core code

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
