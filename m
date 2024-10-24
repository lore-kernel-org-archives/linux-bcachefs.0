Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA571D6DA8;
	Thu, 24 Oct 2024 18:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.104.24.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729795151; cv=none; b=tYsFgVixgfnKpB6Pje8qvt2DNKo5+Gg8lSJL8AWNR1TrgGGJ2ppzrcN8XcO1L4mF02NU/Khqb//9vl86r3+ECmIG/MlJT89l8aQNPQGDy8gIZvZB8GPY82g4hyFZsnrKAYf5q00MhryW22QO16A78TnivzrkY1yJvfk8v2BlN5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729795151; c=relaxed/simple;
	bh=wB9I26UTxgzaakehGDeks85+UkmWYUMo2fEAo3il/QQ=;
	h=MIME-Version:Content-Type:Message-ID:Date:From:To:Cc:Subject:
	 In-Reply-To:References; b=oZ0Rpsud6uD/5ws8VzSFct+4YmFCmA90gbPp2j2PHo9a5QajEjRry0Qh1HvMtQs1e2KJFGmf3wqsVYZuzlIjt7r6hlZBiCauHKLjRanB0RaPrt2LibKqVlW4a+sM3w1ec6Ab9liojue344EJWH2cX/t2lir4uXceM92i6xo+Qhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org; spf=pass smtp.mailfrom=stoffel.org; arc=none smtp.client-ip=172.104.24.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stoffel.org
Received: from quad.stoffel.org (syn-097-095-183-072.res.spectrum.com [97.95.183.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id 768081E11A;
	Thu, 24 Oct 2024 14:30:34 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id 0BD79A0A8A; Thu, 24 Oct 2024 14:30:34 -0400 (EDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <26394.37450.21740.720541@quad.stoffel.home>
Date: Thu, 24 Oct 2024 14:30:34 -0400
From: "John Stoffel" <john@stoffel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: manas18244@iiitd.ac.in,
    linux-bcachefs@vger.kernel.org,
    linux-kernel@vger.kernel.org,
    Anup Sharma <anupnewsmail@gmail.com>,
    Shuah Khan <skhan@linuxfoundation.org>,
    syzbot+e8eff054face85d7ea41@syzkaller.appspotmail.com
X-Clacks-Overhead: GNU Terry Pratchett
Subject: Re: [PATCH] Revert "bcachefs: Add asserts to
 bch2_dev_btree_bitmap_marked_sectors()"
In-Reply-To: <rd4maufxfunrcpzkoo2jszorzl256fiktw3p5yfpnjpu2ajh4l@5wvkfxwzajax>
References: <20241021-revert-assert-bch2-v1-1-e869c7c55bb6@iiitd.ac.in>
	<rd4maufxfunrcpzkoo2jszorzl256fiktw3p5yfpnjpu2ajh4l@5wvkfxwzajax>
X-Mailer: VM 8.3.x under 28.2 (x86_64-pc-linux-gnu)

>>>>> "Kent" == Kent Overstreet <kent.overstreet@linux.dev> writes:

> On Mon, Oct 21, 2024 at 10:18:57PM +0530, Manas via B4 Relay wrote:
>> From: Manas <manas18244@iiitd.ac.in>
>> 
>> This reverts commit 60f2b1bcf519416dbffee219132aa949d0c39d0e.
>> 
>> This syzbot bug[1] is triggered due to the BUG_ON assertions added in
>> __bch2_dev_btree_bitmap_mark. During runtime, m->btree_bitmap_shift is
>> 63 '?'. This triggers both the assertions.

> The BUG_ON() doesn't need to be deleted; we just need to fix the
> validation so it doesn't fire (it doesn't particularly matter if it's
> removed or not, ubsan would catch it without the BUG_ON()).

Shouldn't the BUG_ON() be replaced with making the filesystem readonly
instead if you're going to keep it?  I'd rather have the filesystem
still be mounted and able to be read, but not writeable, instead of
having my system crash before I can do anything.  

John
