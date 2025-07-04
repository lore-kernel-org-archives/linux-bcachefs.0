Received: from smtp153-141.sina.com.cn (smtp153-141.sina.com.cn [61.135.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642D725DAF4
	for <linux-bcachefs@vger.kernel.org>; Fri,  4 Jul 2025 07:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.135.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751612601; cv=none; b=EveO3mWq7HNkGoZO3wyGtyrmKwxZ+ZEGBbwWOnnjRH477XzPmDAuXiE6PizXCOMl7F+M0Q6oVrEy4DZda1iL2g1wiT3gN02IcesSDxOR5+CrwG8M7XDE61J1CVzf5cxs2bWOr5A96V2nGPxCP3HqGy0RGK+77QVdzpPkdgjlZZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751612601; c=relaxed/simple;
	bh=8+9V/ga/MdCUNSwfdcCRGibrOruQGSdItrYrK412UFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GX+U6EI2+FFGzQVNYe1ARrsG9v9D9HBMeAqWa9ilslFtd8uaWIFQEoIXb/FzRKhkVLpSbSAMRQGiG91EL1XCJJ5EuChJfnOzQsXbUTBno0qKusBQVzLPn9Ne7X28HrgooHKwEMN+8dDoCgUPlcwieQJNOxP27rTYVgGhnI84aKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b=huSIbDBE; arc=none smtp.client-ip=61.135.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b="huSIbDBE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1751612591;
	bh=qLtztcG8SjdhwvakcmqX1AXnOof0CO5E07gvNfRESGw=;
	h=From:Subject:Date:Message-ID;
	b=huSIbDBEAtFoYK68EEGdExxcZUs17OOuu6ysG2MZZrb4WFKOYJwNnNocPimywIsEq
	 rgACXuvt9Q2rGWuNrEQYMv8t7hz3t4kHKjlLP8B4P0ef4ff1X/tvYGiTuYsMYRf67L
	 89XWF5Y1WWqVd0NVqd4CipEN2D4EVLbYLIR6Y3IM=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.58.236])
	by sina.com (10.54.253.31) with ESMTP
	id 68677CA30000697F; Fri, 4 Jul 2025 15:03:01 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 1953426816158
X-SMAIL-UIID: 6A00FAF2BDAE4B05A5E3791B1CC7DFBA-20250704-150301-1
From: Hillf Danton <hdanton@sina.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-bcachefs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kerenl@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.16-rc4
Date: Fri,  4 Jul 2025 15:02:46 +0800
Message-ID: <20250704070249.2347-1-hdanton@sina.com>
In-Reply-To: <xl2fyyjk4kjcszcgypirhoyflxojzeyxkzoevvxsmo26mklq7i@jw2ou76lh2py>
References: <ahdf2izzsmggnhlqlojsnqaedlfbhomrxrtwd2accir365aqtt@6q52cm56jmuf> <CAHk-=wi+k8E4kWR8c-nREP0+EA4D+=rz5j0Hdk3N6cWgfE03-Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 26 Jun 2025 23:34:11 -0400 Kent Overstreet wrote:
> On Thu, Jun 26, 2025 at 08:21:23PM -0700, Linus Torvalds wrote:
> > On Thu, 26 Jun 2025 at 19:23, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > >
> > > per the maintainer thread discussion and precedent in xfs and btrfs
> > > for repair code in RCs, journal_rewind is again included
> > 
> > I have pulled this, but also as per that discussion, I think we'll be
> > parting ways in the 6.17 merge window.
> > 
> > You made it very clear that I can't even question any bug-fixes and I
> > should just pull anything and everything.
> 
> Linus, I'm not trying to say you can't have any say in bcachefs. Not at
> all.
> 
> I positively enjoy working with you - when you're not being a dick, but
> you can be genuinely impossible sometimes. A lot of times...
> 
Now I see why your nostrils are so up, dude, because like Linux dancing
out of the Unix box, you are not so tame. Is it wasting minutes for Elon
to think he is richer than Zucker?

BTW I have some difficulty replying offline mails.

Hillf Danton
