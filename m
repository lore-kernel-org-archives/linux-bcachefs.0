Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3547A30E824
	for <linux-bcachefs@vger.kernel.org>; Thu, 19 Jun 2025 18:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750356665; cv=none; b=pNNen96lXP+1MiWgHnXtrjUOEA5Qavg5A63sDyiHY2V0SiwQuUUjamshfPZglzbmEJQhLSliAMuu2bBVKtbXzeIUQL7fsMQV4cLoPoLJvLTNYHvSpX90gU4ZDK2dli8a8IyYDFZr+wRlnYqsHxmxSfTJfUCjTpG/oQGB8NBSElQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750356665; c=relaxed/simple;
	bh=keMVWl3tlYdykGYVcqReAyMwGJJijPC2GIjPDK1YdeU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=m/CZvjXmOwux4/fWNgYWep/CnQ7doFgr4/8u0a4+gMoe/mPhKSlCta7BRy4aaqoE8af9scQ9TWCxyPUSxxA4yScTDYRPH+zhIJyLl70hEyU204nAuXXiMsX4qdHb55kVvGyhzKSYHZc5LuWakBYgGIfC0DsjAJhnFoDnfkaVRDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3ddd051e8e5so8960425ab.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 19 Jun 2025 11:11:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750356663; x=1750961463;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NR3mvQFhXoFMaL/CivSgE+Y2oira8fbZ2+vTXnKv1fU=;
        b=iNKeSCk+eK5M7w5RnJQb55O/G9eis1KrqqhTfwSAnnKPzO1dKRF0tiDqk1vjJOCwmw
         OE38XJy5Ft2oAeeV/JyHh20tKxPYsmXxSXUpV8P3hisucUO5iTzmm5QAMszcZvRrDqlf
         Fz96PVF0toGtXeF3xz0u3cS6TraetPgwLLpjYmgY9jzFK0SIH4lxfifTZYh/Lrb6YPUv
         z7bm0XMuLoWWWuZIoNJ5emUzlp9SHiom3XcZD/RBDefsxcxM4npr0tR5BzNEq3ks3uSm
         FXZOM0E+zMg84xsd79qDpBxPXceffRiXricocEBxaOAyMmedV4WtF0KgMS3UUsGOtJTW
         exNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUTG1+Ut+OS81MJlIpRjEPgTp74GBkYXSYphZw7QNMavtxtK6SoPbuMa2M+HZGxUBDIhY9Pa0S9vQQBfKQu3A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwpjpqTyt0O+Uuub+TSaa4KYo1jTz8iK0A2eRqFEQZSNlmb/c2h
	IOJGY8lLMe0CSTDKxQkXHFHrS9vfrt9/wVIFpvgMH9Tq/z1yLQbqokNGd/0dq256bpPfz8RnUCt
	g7cKtvGlK3JNd8xT01c4qAjj1iI0YVL+cAFkpEUts9OU21sBuRv9NfOTKUCc=
X-Google-Smtp-Source: AGHT+IHKsN+5EOrcnJLw0wAyYzOh5MMo46S+ZrIXZQ79V0uX7SSwP7HQzJmo3TVRbL/P+6pGCJMRhqoVVZHp//GHmyh8liW3XoRR
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:ca0e:0:b0:3dd:d6d5:2d03 with SMTP id
 e9e14a558f8ab-3de07d50c0bmr219466345ab.11.1750356663317; Thu, 19 Jun 2025
 11:11:03 -0700 (PDT)
Date: Thu, 19 Jun 2025 11:11:03 -0700
In-Reply-To: <67b2eaf7.050a0220.173698.001f.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <685452b7.a00a0220.137b3.0014.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_reconstruct_snapshots
From: syzbot <syzbot+b4cb4a6988aced0cec4b@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 757601ef853359fe2d57d75c00b5045f62efc608
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sun Jun 8 15:40:00 2025 +0000

    bcachefs: Don't put rhashtable on stack

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13b01d0c580000
start commit:   128c8f96eb86 Merge tag 'drm-fixes-2025-02-14' of https://g..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=e55cabe422b4fcaf
dashboard link: https://syzkaller.appspot.com/bug?extid=b4cb4a6988aced0cec4b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16d5d9b0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=112099a4580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: bcachefs: Don't put rhashtable on stack

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
