Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88227258EC1
	for <linux-bcachefs@vger.kernel.org>; Sun, 28 Dec 2025 06:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766903344; cv=none; b=OGyk8HsHqGfY9vWcGr9K3IShjsP1kndhT5MGJ+TuXYQy8sHm9OemF104ZzTGyeBlTn+iH6vErBo6Zgn/gOW41//DKG+O2/KrvT8blhJJDI8fKzfdMW1Qgjd5/4n1lUqOu77eLLYow91HGK+A90Sm5yope5AdU8th/oqk78VinKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766903344; c=relaxed/simple;
	bh=Inljx6UOoK9th0Yw9ul8xLEL3W4o8tpjYeNnAkDOmxk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=NwKCelxWTa5eEkzBsT1cZifEZDt4Akogwvd4DwX522imLZ3vhSJeLqbP3Xw0BupQsKV2OWbtM7oSWta7sl8wbk+QE7kHGUzZAwNCTkAGfdeof5GRr66l2KrT11lv9Zgl/yUyqfu/LLBvY1lX1+rQvEZMGxHhlmGSKAHKDYTNImk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-65eb49dd974so8631959eaf.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 27 Dec 2025 22:29:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766903341; x=1767508141;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WqWaYjXGpL0SCXHVfAwZczGoXfLd9iZju3rBMa/XlsI=;
        b=PNJ6+mp8ZvDo3bsqGm+fjlz8UqMlqnBdJDkrq8NvwJoFWQfIQ2AnylAzno8mh9UoKP
         UMP6oE066iQCMw8mdLihrrqY0xLzCtxG5XEAE/tpC/55shsFqkB4f3rUR3CzhEpWFif7
         V4Vsvo3PrVn3PotUSCC9KVrDVaoB+GdoSWkVVTRVM2IqY9jZ88XZHK0A9czrvMdLfwpk
         R3TF5w1HBAlhLN/gfviU7StY2D+uLfB3YDzAFFOwv229fW830e87g5KveL0fImVgAflE
         TmJt0k98u2wlKwWow4OefPzq4M7QUbz/uX1FJIsQL5Ifhy/MvwneVvmiR3Fj1SKv4S2i
         4bQg==
X-Forwarded-Encrypted: i=1; AJvYcCUtZSJsrN0gph4kVOm5V/p9aKPPb67ubSC0OHmAy0Ty/UIWLCy2Dw0g54d3DPwkkHc25EPQ0s/aZs7Gmk2r9w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyBO6785rTTGonYHBdnJ5hTnt9xMUJ8vn+P/NZfegoh8hms9/Mb
	mWDQGbf0k9PCGDfPLRAjhaATOzCIl77UX+2xVeDh2mHckWlvhhjjblLhuW2CYimdgwzCLX9pz4Z
	rl/R2AP5rgrfM+9KPNaxmOESEXQSoCpI9RkeSXzRfGO0jymFDbbfsm8Cn2Xk=
X-Google-Smtp-Source: AGHT+IEoS0rAjcG/+fGcGmjafzr1ie5EibCfjAHuWQ1bamSqVqpqVq5pUPYA4JV9/ivc0D0yU9QEcaQ+4125sqT5bkop/MWm91yt
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:d744:0:b0:65c:f062:bdde with SMTP id
 006d021491bc7-65cfe799322mr10615394eaf.36.1766903341612; Sat, 27 Dec 2025
 22:29:01 -0800 (PST)
Date: Sat, 27 Dec 2025 22:29:01 -0800
In-Reply-To: <682e11b1.050a0220.ade60.09e5.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6950ce2d.a70a0220.c527.0006.GAE@google.com>
Subject: Re: [syzbot] [lsm?] [integrity?] INFO: task hung in
 process_measurement (3)
From: syzbot <syzbot+cb9e66807bcb882cd0c5@syzkaller.appspotmail.com>
To: bfoster@redhat.com, dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com, 
	jmorris@namei.org, kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, paul@paul-moore.com, 
	roberto.sassu@huawei.com, serge@hallyn.com, syzkaller-bugs@googlegroups.com, 
	torvalds@linux-foundation.org, zohar@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit f2c61db29f277b9c80de92102fc532cc247495cd
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Sep 29 20:43:52 2025 +0000

    Remove bcachefs core code

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10499e2a580000
start commit:   172a9d94339c Merge tag '6.15-rc6-smb3-client-fixes' of git..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=ea35e429f965296e
dashboard link: https://syzkaller.appspot.com/bug?extid=cb9e66807bcb882cd0c5
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16836e70580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1617a2d4580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: Remove bcachefs core code

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
