Received: from plesk.hostmyservers.fr (plesk.hostmyservers.fr [45.145.164.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFFA813B797;
	Wed, 23 Apr 2025 17:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.164.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745428722; cv=none; b=QiqGdMxkhhPPWEmqMOhe8AMHvbo8uRzTYteU/WYBxxyWLa7EcQkg3tSkUCKYQudQmp/+NIZKJK82c4KP4v33ewZr/2z97d4GArcIJVKvhUgq10Sk54CITWECJfQLIzgBxxXYfYg4n92Yh0qzmNLBiLgwZasWYNCU7e1bdt4VRow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745428722; c=relaxed/simple;
	bh=q7KU0r1+vVNvWSaAj7qIPrHly9wPzn7Asoq03Ne3hVw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g25smSQ2xb+G0jB0MwT9QmjvmfWUJjG4as7bcZLqOeHa1V0p9svquKxJcC4E52xbZK7GM9PMa7ud8qDDC3sLXHW+OATjVxjZwQ9/FsVPqtCLZWCqs7KRKyw1U18hABscfBBDgGjvmkE8Y+NhHpbx1DycILfOXMoA4rRDHmivg7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=arnaud-lcm.com; spf=pass smtp.mailfrom=arnaud-lcm.com; arc=none smtp.client-ip=45.145.164.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=arnaud-lcm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arnaud-lcm.com
Received: from [IPV6:2a01:e0a:3e8:c0d0:d851:318b:70da:57a7] (unknown [IPv6:2a01:e0a:3e8:c0d0:d851:318b:70da:57a7])
	by plesk.hostmyservers.fr (Postfix) with ESMTPSA id 4B8765568F;
	Wed, 23 Apr 2025 17:18:36 +0000 (UTC)
Authentication-Results: Plesk;
        spf=pass (sender IP is 2a01:e0a:3e8:c0d0:d851:318b:70da:57a7) smtp.mailfrom=contact@arnaud-lcm.com smtp.helo=[IPV6:2a01:e0a:3e8:c0d0:d851:318b:70da:57a7]
Received-SPF: pass (Plesk: connection is authenticated)
Message-ID: <53206807-b595-4fec-8113-a81a24c3e8db@arnaud-lcm.com>
Date: Wed, 23 Apr 2025 19:18:34 +0200
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Sub volumes handling in bch2_fsck_update_backpointers
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: syzbot+843981bb836d699c07d1@syzkaller.appspotmail.com,
 linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <6806d857.050a0220.f25bb.07a8.GAE@google.com>
 <20250423154531.376838-1-contact@arnaud-lcm.com>
 <22hlu76p6uzlu6zexcjxgpijenfba3en4bx74nx6etr2mpgw4g@liyxgcpx7hbl>
Content-Language: en-US
From: Arnaud Lecomte <contact@arnaud-lcm.com>
In-Reply-To: <22hlu76p6uzlu6zexcjxgpijenfba3en4bx74nx6etr2mpgw4g@liyxgcpx7hbl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-PPP-Message-ID: <174542871663.1969.3373994792378099390@Plesk>
X-PPP-Vhost: arnaud-lcm.com

Would you be  okay if I try to handle it ? I am fairly new to bcachefs 
but I am really interested to get involve into it, I like the project.

On 23/04/2025 18:47, Kent Overstreet wrote:
> On Wed, Apr 23, 2025 at 05:45:31PM +0200, Arnaud Lecomte wrote:
>> Hey everyone, in fsck.c, we have:
>> /*
>>   * Prefer to delete the first one, since that will be the one at the wrong
>>   * offset:
>>   * return value: 0 -> delete k1, 1 -> delete k2
>>   */
>> int bch2_fsck_update_backpointers(struct btree_trans *trans,
>> 				  struct snapshots_seen *s,
>> 				  const struct bch_hash_desc desc,
>> 				  struct bch_hash_info *hash_info,
>> 				  struct bkey_i *new)
>> {
>> 	if (new->k.type != KEY_TYPE_dirent)
>> 		return 0;
>>
>> 	struct bkey_i_dirent *d = bkey_i_to_dirent(new);
>> 	struct inode_walker target = inode_walker_init();
>> 	int ret = 0;
>>
>> 	if (d->v.d_type == DT_SUBVOL) {
>> 		BUG();
>> 	} else {
>> 		ret = get_visible_inodes(trans, &target, s, le64_to_cpu(d->v.d_inum));
>> 		if (ret)
>> 			goto err;
>>
>> 		darray_for_each(target.inodes, i) {
>> 			i->inode.bi_dir_offset = d->k.p.offset;
>> 			ret = __bch2_fsck_write_inode(trans, &i->inode);
>> 			if (ret)
>> 				goto err;
>> 		}
>> 	}
>> err:
>> 	inode_walker_exit(&target);
>> 	return ret;
>> }
>>
>> What is the current state for handling subvolumes ? In someone already working on or it is something we don't want to implement
>> for some reasons ?
> This does need to be handled, I haven't started on it yet.
>
> I did just fix another subvolume root backpointers bug, which makes this
> one easier - now, only the newest snapshot version of a subvolume root
> inode needs to have a backpointer.
>
