Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057F0109
	for <linux-bcachefs@vger.kernel.org>; Tue,  5 Dec 2023 13:35:59 -0800 (PST)
Received: from [192.168.1.123] (ip5b4280bd.dynamic.kabel-deutschland.de [91.66.128.189])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: buczek)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 4F08861E5FE03;
	Tue,  5 Dec 2023 22:35:43 +0100 (CET)
Message-ID: <12f711f9-70a2-408e-8588-2839e599b668@molgen.mpg.de>
Date: Tue, 5 Dec 2023 22:35:42 +0100
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Donald Buczek <buczek@molgen.mpg.de>
Subject: Re: How to cope with subvolumes and snapshots on muti-user systems?
To: NeilBrown <neilb@suse.de>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org, Stefan Krueger <stefan.krueger@aei.mpg.de>
References: <3222cf4b-8f9d-4576-b2e2-c78e5655f4dc@molgen.mpg.de>
 <20231129214328.efbfpl3javifvwk5@moria.home.lan>
 <63ca9346-6bec-40d5-8f7e-4181721652f1@molgen.mpg.de>
 <20231130073948.v3jkmmvtwnefwvq3@moria.home.lan>
 <170137665630.7109.15666373159604652834@noble.neil.brown.name>
 <3b2720ca-23eb-4666-b04f-5bff4b1ac1cf@molgen.mpg.de>
 <170172993746.7109.10813288295717935377@noble.neil.brown.name>
Content-Language: en-US
In-Reply-To: <170172993746.7109.10813288295717935377@noble.neil.brown.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/4/23 23:45, NeilBrown wrote:

>> Hmm, isn't a (struct file_handle) filehandle supposed to be opaque?
>> I'm not sure if it is a good idea to stick filesystem-specific
>> meta-information (like a subvolume ident) into special bits of opaque
>> numbers (whether inode number or filehandle) at all.
> 
> Yes, a filehandle is opaque.  Digging around inside it would be wrong.
> 
> My understanding was that your primary need was not to know where
> subvolumes were, but to know when two files were different even though
> they had the same inode number.  filehandles can be used to tell if two
> files are different with total reliability.

You are right, these are two orthogonal requests and they were not clearly separated in this thread, thus the misunderstanding.

I think, unique identifiers for different objects are a must. I think in bcachefs, the filehandles returned by name_to_handle_at() already are unique, so this could be used by userspace to work around duplicate inode numbers right away. Even the hashing you proposed could be done in userspace if it wants to fold the data into to some existing format with inode numbers.

>> The information could also be made available via specialized ioctl(s)
>> as an alternative to xattr.
> 
> ioctl would be worse than xattr.  statx extension would be best if you
> need something that filehandle cannot provide.
> 
>>
>> One disadvantage of embedded in filehandle, xattr or ioctl is that
>> userspace would need an extra syscall for each directory just to see
>> if this is a subvolume or a snapshot, which most of the time it is
>> not.  Maybe, even an otherwise unnecessary open is needed to get a
>> consistent view between multiple information-retrieving syscalls.  If
>> only statx() was extendable.
> 
> uhmm... statx is extendable...
> Adding a STATX_ATTR_SUBVOLUME_ROOT attribute flag shouldn't be too
> controversial, if a clear need and use-case were presented.

When the inode numbers are made unique one way or the other but tools like backup or mirror have no way to identify snapshots, they would just copy the snapshots removing the deduplication on the destination. If they had a way to figure out, that they are about to walk into a new volume, they could instead do a more sensible thing like stop and cry for help or whatever is explicitly configured.

statx() would be very nice, because you can avoid additional system calls. I wish, we could get the file_handle in the same call, but I assume that is not possible to be added to statx() because of the potential big and unknown length. However, I assume the combination of volume-ident and inode number, which both would be available from one statx() call, are also unique, so this should do, too.

Best

   Donald

>> You don't have this problem with a crafted fsid.  Then creating a
>> subvolume or a snapshot could be seen as an implied mount.  Maybe
>> that's not the worst solution.
> 
> No, probably not the *worst*, but not far from it.  It is a really bad
> non-solution.
> 
> Have a look at
>   https://github.com/SUSE/kernel-source/blob/master/patches.suse/vfs-add-super_operations-get_inode_dev
> 
> This is a monstrosity that SUSE needs to carry so that the fake fsid
> that btrfs generates for subvolumes is used consistently.  There are
> various interfaces in the kernel that use fsid/inode - some just for
> error reporting, others for more substantial things.  In mainline linux
> these do the wrong thing for btrfs subvolumes.
> 
> Please don't copy this mistake into bcachefs.
> 
> Thanks,
> NeilBrown
> 
>>
>> Best
>>
>>     Donald
>>
>>>
>>> NeilBrown
>>>
>>>
>>>>
>>>>> What to you think about the suggestion to make creation of snapshots
>>>>> (and possible volumes, not sure about that) a privileged operation
>>>>> (optional, of course) ? I know, multi-user is niche nowadays, but for
>>>>> me it looks like a rather cheap workaround.
>>>>
>>>> Yeah, that's not an unreasonable ask.
>>>>
>>>
>>
>> -- 
>> Donald Buczek
>> buczek@molgen.mpg.de
>> Tel: +49 30 8413 1433
>>
> 

-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433
