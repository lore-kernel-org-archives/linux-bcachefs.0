Received: from out203-205-221-245.mail.qq.com (out203-205-221-245.mail.qq.com [203.205.221.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C7F4C80;
	Wed, 31 Jul 2024 01:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722389763; cv=none; b=p1cogMrsbw3AYFHKRFwosQXUFU88chSesa/hOgM5OTFhVFxUJ5p/86PiSi/D2WGcn7Ya8ofPYsba373HjRfFXt4bf0JE34sNyJNM+xzPXdY2lZaEf50DSfO2+cp0n9zPtymyF7TigmULWdsnVR0GSIjE7JQOcSXBIZCKU/6gZgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722389763; c=relaxed/simple;
	bh=dTqWL5q4Eij9ZmgP3ZNingNO/Df/MzIfctKb2/wovK4=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=Xd2lMJHJB/6DBCd4n0h6/+48i1xQFqOeU5E6HGmrxo7+9XFUs/U2Nj3A7Taru8W6o7oOlKSVGM2MD7OypbiiYTf2gIwxWp55yiQpoTZRwDq6rMXII85amGANWJLk1jfUWTtjxHLznaUAeu3YU26k2H7jn8z7DNvse0eVE4JKW/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=y/Wrdc65; arc=none smtp.client-ip=203.205.221.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="y/Wrdc65"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1722389758; bh=kkAa6icvMy++tO8DHmrSjlvrPU6/p29/N18+pIiRkuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y/Wrdc65CRS+e9hQvNsom4Hsb3bHhPosghQa6wlReGzQKD26p6lfUsOwYzAjjK+r9
	 ObNXzaky5/jGiw657MLbe2dYlSvR2T3/IwoyR6ncm1uJz/YvPUJXVIAyh8+aPB+JQE
	 jJjIrFIBlg5Bb6qMK/oSqk1gRUSsm6PAUKrBdb6Q=
Received: from pek-lxu-l1.wrs.com ([111.198.225.4])
	by newxmesmtplogicsvrszb9-1.qq.com (NewEsmtp) with SMTP
	id 8F8032B0; Wed, 31 Jul 2024 09:35:56 +0800
X-QQ-mid: xmsmtpt1722389756tyrsd2zy4
Message-ID: <tencent_DB74336E9E1D1B304BFF1B3F25DBBAA6BB08@qq.com>
X-QQ-XMAILINFO: M0PjjqbLT90wiVmMAq+zrkzh4WfQc8DcvUQTYRyyFNArWnC4jOFixdAa4SoKt3
	 h27BsQpTeqVwwFJKHFhueKYxO0TiUjz9N9q/JYl2tYoMGiaYQvJzY+Y+tSyNTki/d4GlSLuwtXnT
	 8sDjk//IxJmyK0a4m1INpe7D7HwLes/m8CU4UijugO9XcMboAPQ1wnuB36xkD259mv/3L7joqxA2
	 +yoYy0LqUSGbR1KAqMNRlcG3PU+OG12GfjpYwOc0ZZoxrVEN6QP6pKxCV1Idq8eDfln5/pSq27nm
	 UIDLuAyLPYmm7nBFam/g7O7yChroviTWUo0l5u2wgeyTPysMwXLUzPTdbjV39jHDFRujF3OroWSp
	 +SIsSLFkcAbrwbF/G3jmlaJuqHWf5C7mGW0FU+BxNyOX06RggZOXxWy7GibLopjPgUBMSKKRJao2
	 UmUWrzCK7jJMeQFe9SDiriue6yDGKl1rCnBcds6OF/dzStlRRiVYSrcwAD6x0aP66X26F5Ysu9YB
	 F2aLoiXsKE+T+Hp2zXIwzi5UHmeTVoo2UACgb8bLGQtO4V20ouTVrCQNiqJ5lGYo20d+1IpueNyJ
	 MfaJkOZ4EV4HaHli6KeXCHK7fmQ5Az4vUROLXeoHlkqhnJTJEnYlDO3Ib8hqAZgNknYjEFQ7//XU
	 6t/SFuF45iFxNDKGK+QZNEG2jFxHAmGQHRwRx27h2z/g6DA/I/GiEr1f3awjLDDmOhSbmsQYF6O6
	 500lCYvvITybeZ8fI4Uo2rp/sHwQbBzEuX4ELuEMP5HMUXIxtwzgRVOAF9XOTqBRiY0GM4lQ0Myr
	 /ZmCNDrTg4jDoUx6xEvtMVQqsXggjQKEjHP8mzfXXZpjdYBLu2gofuVl+ieS+mwP9TAc+FBv2jaG
	 P5x6R60QACmqFLtrisrERlVascMutKTcGLqovqVD6yAJLS+XaQTg6FxpVxXxzFFlbTPHX1YwO9
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
From: Edward Adam Davis <eadavis@qq.com>
To: kent.overstreet@linux.dev
Cc: eadavis@qq.com,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+05d7520be047c9be86e0@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH V2] bcachefs: Add checks for entry's _data bytes
Date: Wed, 31 Jul 2024 09:35:56 +0800
X-OQ-MSGID: <20240731013556.38650-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <apj4zcnnq5nwcly4mnl76uiuwibkzayqd3beeum3p436kycksf@co4yrhzxo7kl>
References: <apj4zcnnq5nwcly4mnl76uiuwibkzayqd3beeum3p436kycksf@co4yrhzxo7kl>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot report slab-out-of-bounds in journal_entry_dev_usage_to_text,
it because vstruct_bytes(entry) smaller than sizeof(struct
jset_entry_dev_usage), overflow occurs when calculating the difference in
jset_entry_dev_usage_nr_types(u).

Reported-by: syzbot+05d7520be047c9be86e0@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 fs/bcachefs/bcachefs_format.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index e3b1bde489c3..d536da101e89 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -1252,6 +1252,11 @@ struct jset_entry_dev_usage {
 
 static inline unsigned jset_entry_dev_usage_nr_types(struct jset_entry_dev_usage *u)
 {
+	if (vstruct_bytes(&u->entry) < sizeof(struct jset_entry_dev_usage)) {
+		pr_info("entry data bytes %u is too small", vstruct_bytes(&u->entry));
+		return 0;
+	}
+
 	return (vstruct_bytes(&u->entry) - sizeof(struct jset_entry_dev_usage)) /
 		sizeof(struct jset_entry_dev_usage_type);
 }
-- 
2.43.0

