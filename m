Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB2C269808
	for <linux-bcachefs@vger.kernel.org>; Sun, 15 Jun 2025 15:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750001884; cv=none; b=dzRzSvyJYiVTvZpamtFGf5IU+WpZTBameKr7CPsYjtRwinw1w0/fQUNdeLhz33HqdRubPxZqlb3G0oYx6Q3V8ogAXfdyJZQnHuY/ElxwhPOaf8HawGZp5nY1AAfHwfNxY0jkHHJA4pl6zUVtlqWur140ulUZWb0CP2VLOUR41ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750001884; c=relaxed/simple;
	bh=ijQOwQ9iLGs7bxEf8zhftzsVWohV2WJEj2zJYqNwyEc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=nU5QJ+ONy7XhZaeXyKLbF6z2OkuSQ3sko57bnhpQaLXi6kPoB2dNbhzYMnjQ1drJmJuOT2BRAnQMBg5Z4oBTCZsRS/6MEm8Daoa7Bb5YwTmVBsbQIS0vG+gbd9lRW7aRHFT+QPSIwkeSMNvAVCm1QqkTZDbWH3DtYLd8GLfME7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-86cfea700daso389807539f.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 15 Jun 2025 08:38:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750001882; x=1750606682;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZIgiGfV2mhWTCwQ1ryP8MSJgY81toabb+Gz0Yy/VRSU=;
        b=aVPmeKSGUn90eM50G9+vzp3qLltHtnDp5DOg25CR5FO8CsagefnCmR+bT6IvNr2cRx
         dOAPGt24gpRQ1ZC7LM3EhuWpz1MSf92JNyLk05bAs1q+PF/slzCrUYH8Vq7LADlY1Y9g
         QDK0wXdPpOhvh52E2XONB/KVBjQT4/VWCPU6vH85m07vKZUObUDEQb0ElNxi0i8KnkKH
         z8RDbJLVOjAWe5wCT+qGOCKHLGbWo5lJpcpFaGiWErtsCHYcFeuqMz3Ac9vBbGS+Pm6p
         vQXpBSnnqaR8P/yRAwogd4DFlfvacSex84+OMYyY7ek5Ts2FhZD7Mh5HIb/3BL6zSObs
         GIyw==
X-Forwarded-Encrypted: i=1; AJvYcCVTyKqfZGnN5FDwEDFK7tAeT2pl+QfJrqtzdCXmwC8e3m/qcSSN15tjTaAj+41zKuoNjBm3I2NqtVZsEEgoLg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwV9B56hweJd2kldcA2Uxh2bGNZHuMmmvPIPkGlANbWG/qkJsDm
	P0pY6iiYZL7torggfY9Pna1HKXf+nJRmk5n0TDfZB2wJu/N2/MIiuyryAywKd98gUOxxyimYSmg
	9vGhf4YDju5fg72j1nU+f40qBEtaftCeyqrKQ94b4dPbcnaqc3oglExklE+g=
X-Google-Smtp-Source: AGHT+IFC9XpgywAk8AlLteR10NiHvg63i5ZJ6Uus66jHEEqXnJxTErbs8tFA8mP5911mYdzHSbqOPuVfyRx6dU0ZRsWZSRME/3jV
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1985:b0:3dd:c067:97b6 with SMTP id
 e9e14a558f8ab-3de07c3ef6emr63225675ab.1.1750001881968; Sun, 15 Jun 2025
 08:38:01 -0700 (PDT)
Date: Sun, 15 Jun 2025 08:38:01 -0700
In-Reply-To: <684c57c4.a00a0220.279073.0015.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <684ee8d9.050a0220.be214.02c0.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in __bch2_bkey_compat
From: syzbot <syzbot+4908f37148402680dfec@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit cd3cdb1ef706a1ac725194d81858d58375739b25
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Tue Apr 22 13:14:19 2025 +0000

    bcachefs: Single err message for btree node reads

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11b67d70580000
start commit:   27605c8c0f69 Merge tag 'net-6.16-rc2' of git://git.kernel...
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13b67d70580000
console output: https://syzkaller.appspot.com/x/log.txt?x=15b67d70580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=162faeb2d1eaefb4
dashboard link: https://syzkaller.appspot.com/bug?extid=4908f37148402680dfec
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10f9f682580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17ecb9d4580000

Reported-by: syzbot+4908f37148402680dfec@syzkaller.appspotmail.com
Fixes: cd3cdb1ef706 ("bcachefs: Single err message for btree node reads")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
