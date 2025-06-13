Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E13242D63;
	Fri, 13 Jun 2025 02:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749782465; cv=none; b=QM+fYDEgeB85JyC7/elhuF04iFi+MENE+7tLKZLdR5BXIUjaS+WYrJWR6Nq0Gm2Tqy72bQCChK3nubmQnldVd8OlqF+WWEuFWthB/wwLzqHiQNwLjFrpavZ04Diqlgyfl2hI55yfCCqukmCdAddt3ZQJTJ/snuHjBTFFRieXOqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749782465; c=relaxed/simple;
	bh=lsjklWC9GrAQ9ie/5+Lzoh1PHIpWWvojIFBifi896TU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=kCylAaZyIDh8r6oT18lfmP09NNN1lp0OiIPycdPHosi7/N4pIlsepIThWgvKMa3V5m8W+rYDCVaKhx1C1XeryBu5P5iA17nYlIOI58U6v07NcmP+hTrjnYfrRi8LiB0dMoSJokLOBj8ydixnYg3ng46xjO4fhT+9nO283McaRUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D821120979;
	Fri, 13 Jun 2025 02:41:02 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf09.hostedemail.com (Postfix) with ESMTPA id 9B6F320028;
	Fri, 13 Jun 2025 02:41:00 +0000 (UTC)
Date: Thu, 12 Jun 2025 22:40:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org
Subject: Unused trace events in bcachefs
Message-ID: <20250612224059.39fddd07@batman.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9B6F320028
X-Stat-Signature: yz9soinwdst1pye7c6up6ctq54kacya3
X-Rspamd-Server: rspamout05
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19kKEAnJrKE8y18aXdiNX8Z5aGuXQ5h6yk=
X-HE-Tag: 1749782460-738617
X-HE-Meta: U2FsdGVkX18gTE54R2Lx2cMLonh0oVguR0QYXKsGrGY6SoK1pFa0Th/mR7lGSUaYtKUuichQZuRBu8PplIkUhyUIvFOFkSVsrMzrBlqzAcVNhz9iIU7y5E6AMQqzhkw5jX7Bbs/OuYyQ8kSuq4ku+/e04rRYk5ppEn4j9pBH/hvhSQWPvVK5nJJ0fZKzAIcpXrxnjNxdjnnv8yLLi4QPDFpssY40diStjgnnEAiNkpUdBxM8531hJHiSNvKm4bhdVLy2gTnrxPjImygOgsMV6tTCVpMLlujrc75f+9LgrMAq5hDBiMrnz8+43lWqOzzT2FPt7/6NhErH0uSfGwp9FJ4wEEWdLEJg16gQFk4FPVg1sGzqikR9pGAM3lXqfTvnlK6aef/nBBIWVeJu4RKeeA==

I have code that will trigger a warning if a trace event is defined but
not used[1]. It gives a list of unused events. Here's what I have for
bcachefs:

warning: tracepoint 'trans_restart_journal_preres_get' is unused.
warning: tracepoint 'trans_restart_fault_inject' is unused.
warning: tracepoint 'trans_restart_relock_after_fill' is unused.
warning: tracepoint 'trans_restart_key_cache_upgrade' is unused.
warning: tracepoint 'trans_restart_relock_key_cache_fill' is unused.
warning: tracepoint 'trans_restart_traverse' is unused.
warning: tracepoint 'trans_restart_key_cache_key_realloced' is unused.
warning: tracepoint 'trans_restart_write_buffer_flush' is unused.
warning: tracepoint 'btree_path_free_trans_begin' is unused.

Each trace event can take up to around 5K in memory regardless if they
are used or not. Soon there will be warnings when they are defined but
not used. Please remove any unused trace event or at least hide it
under an #ifdef if they are used within configs. I'm planning on adding
these warning in the next merge window.

Thanks,

-- Steve

[1] https://lore.kernel.org/linux-trace-kernel/20250612235827.011358765@goodmis.org/
